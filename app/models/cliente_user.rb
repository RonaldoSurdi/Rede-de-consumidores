class ClienteUser < User
  @@lock = Mutex.new

  SEXOS = { masculino: "Masculino", feminino: "Feminino" }
  ESTADOS_CIVIS = {
    0 => "Solteiro(a)",
    1 => "Casado(a)",
    2 => "Divorciado(a)",
    3 => "Separado(a)",
    4 => "Viúvo(a)",
  }

  after_initialize :default_values
  before_save :setar_codigo_cartao

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  belongs_to :plano_adesao, class_name: "PlanosAdesao"
  belongs_to :cliente_user_indicador, class_name: "ClienteUser"
  belongs_to :padrinho, class_name: "ClienteUser"

  validate :has_cities?
  validates_presence_of :juridica_fisica, :cpf_cnpj, :logradouro, :numero, :bairro, :celular, :plano_adesao, :cidade, :cep
  validates_uniqueness_of :numero_cartao
  validates :estado_civil, :data_nascimento, :sexo, presence: true, if: :fisica?
  validates :razao_social, presence: true, if: :juridica?
  validates :data_nascimento, date: { before_or_equal_to: Date.today, allow_blank: :fisica?, message: 'não pode ser maior que a data atual' }
  validates :cep, length: {is: 9, message: "formato incorreto"}
  validate :maioridade, if: :data_nascimento?
  validate :nome_completo
  validate :senha_somente_com_numeros
  validates :password, length: {is: 6}, allow_blank: true

  has_many :transacoes
  has_many :movimentos, foreign_key: "user_id"
  has_many :pagamentos, foreign_key: "origem_id"

  scope :indicacoes, ->(user = nil) {
    user = user.id if user.is_a? User

    query = ClienteUser
      .joins("Left Join pagamentos On pagamentos.origem_id = users.id")
      .joins("Left Join planos_adesoes p On p.id = pagamentos.planos_adesao_id")
      .where("pagamentos.id = (Select Max(id) From pagamentos Where pagamentos.origem_id = users.id and status = 'pago' and categoria = 'anuidade')")

    if user
      query
        .select("users.nome, pagamentos.updated_at as data_ativacao, Case plano_padrinho.quantidade_indicacoes When 1 Then 1 Else p.quantidade_indicacoes End As pontos_indicacao")
        .joins("Left Join users padrinho On padrinho.id = #{user}")
        .joins("Left Join planos_adesoes plano_padrinho On plano_padrinho.id = padrinho.plano_adesao_id")
        .where(padrinho_id: user)
    else
      query
        .select("users.nome, pagamentos.updated_at as data_ativacao")
        .where(padrinho_id: nil)
    end
  }

  def tipo
    "Cliente"
  end

  def has_cities?
    errors.add(:cities, "não pode ficar em branco") if self.cities.to_a.length != 1
  end

  def saldo
    Saldo.para(self).saldo
  end

  def gerar_codigo_cartao
    @@lock.synchronize do
      city = "%03d" % cities[0].id
      plano_adesao = "1" #Alterado para deixar 1 fixo, pois o usuário pode alterar o plano de adesão
      ultimo_codigo = ClienteUser.where("numero_cartao like ?", "#{plano_adesao}#{city}%").maximum("numero_cartao") || "#{plano_adesao}#{city}000000"
      ultimo_codigo.to_i + 1
    end
  end

  def save_with_pagamento
    ret = false

    ActiveRecord::Base.transaction do
      ret = save

      if ret && self.plano_adesao.vlr_anuidade.to_f > 0.0
        pagamento = Pagamento.new
        pagamento.status = :aguardando
        pagamento.origem = self
        franquia = FranquiaUser.joins(:cities).where("cities.id = ?", self.cities[0].id).first
        pagamento.destino = franquia
        pagamento.valor = self.plano_adesao.vlr_anuidade
        ret = pagamento.save
      end
    end

    ret
  end

  def anuidade_paga?
    plano_adesao.vlr_anuidade.to_f == 0 || Pagamento.where(status: :pago, origem: self, categoria: :anuidade).where("updated_at >= ?", (Date.today - 1.year).at_beginning_of_day).order(updated_at: :desc).first
  end

  def pode_resgatar?
    ret = anuidade_paga? != nil
    unless ret
      ultimo_pagamento = Pagamento.where(status: :pago, origem: self, categoria: :anuidade).order(updated_at: :desc).first
      ret = ultimo_pagamento && (DateTime.now.to_date - ultimo_pagamento.updated_at.to_date).to_i < 180 # Se venceu anuidade só pode resgatar até 6 meses depois
    end
    ret
  end

  def vencimento_anuidade
    pagamento = anuidade_paga?
    pagamento.updated_at + 1.year
  end

  def numero_cartao_formatado
    numero_cartao.match(/(\d{1})(\d{3})(\d{3})(\d{3})/).to_a.slice(1..100).join(" ")
  end

  def tipos
    TipoUsuario.where("quantidade_indicacoes <= ?", self.quantidade_indicacoes).order(:quantidade_indicacoes).to_a
  end

  def tipo_atual
    tipos.last
  end

  def consumo_medio_mensal(quantidade_meses)
    scope = Transacao
      .where(cliente_user: self)
      .where("cancelada Is Null Or Not Cancelada")
      .where("created_at >= ?", (DateTime.now - (quantidade_meses * 30)).at_beginning_of_day)

    menor_data = scope.minimum(:created_at)
    if menor_data
      diferenca_em_dia = [(DateTime.now.to_date - menor_data.to_date).to_i, 1].max
      (scope.sum(:vlr_gasto) / diferenca_em_dia) * 30
    end
  end

  def fisica?
    self.juridica_fisica.upcase == "F"
  end

  def juridica?
    self.juridica_fisica.upcase == "J"
  end

  def uf
    split = self.cidade.split("-")
    split.last.to_s.strip
  end

  protected

  def confirmation_required?
    true
  end

  def setar_codigo_cartao
    self.numero_cartao = gerar_codigo_cartao if numero_cartao.blank?
  end

  def default_values
    self.juridica_fisica ||= "F"
    self.plano_adesao ||= PlanosAdesao.pessoal.first
    self.quantidade_indicacoes ||= 0
  end

  def maioridade
    errors.add(:data_nascimento, "Só é permitido cadastro de pessoas com mais de 18 de anos") if (Date.today -  18.year) < self.data_nascimento.to_date
  end

  def nome_completo
    errors.add(:nome, "Informe o nome completo. Ex: Nome Sobrenome") if self.fisica? && self.nome.to_s.split(" ").length < 2
  end

  def senha_somente_com_numeros
    errors.add(:password, "Permitido somente informar números na senha") if !password.blank? && !password.gsub(/\d/, "").blank?
  end
end