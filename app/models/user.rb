class User < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller ? controller.current_user : nil }

  before_save :before_save

  devise :database_authenticatable, :validatable, :recoverable
  before_destroy :validate_destroy

  validates_presence_of :nome
  has_and_belongs_to_many :cities
  has_one :config_boleto
  has_many :movimento
  has_many :a_receber, class_name: Pagamento, foreign_key: :origem_id
  has_many :a_pagar, class_name: Pagamento, foreign_key: :destino_id
  has_many :banners
  validates_uniqueness_of :cpf_cnpj, if: :cpf_cnpj
  validate :validar_cpf_ou_cnpj, if: :cpf_cnpj
  validate :validar_celular

  before_destroy { cities.clear }

  def cpf_cnpj=(cpf_cnpj)
    write_attribute :cpf_cnpj, cpf_cnpj.to_s.gsub(/\D/, "")
  end

  def codigo_com_nome
    "#{self.id} - #{self.nome}"
  end


  def cpf_cnpj_formatado
    if juridica_fisica.to_sym == :F
      Cpf.new(self.cpf_cnpj).to_s
    else
      Cnpj.new(self.cpf_cnpj).to_s
    end
  end

  def franquia
    FranquiaUser
      .joins(:cities)
      .where(cities: {id: User.select("cities.id").joins(:cities).where(id: self.id)})
      .first
  end

  protected

  def confirmation_required?
    false
  end

  def validar_cpf_ou_cnpj
    if juridica_fisica
      if juridica_fisica.to_sym == :F
        errors.add(:cpf_cnpj, "CPF inválido") unless Cpf.new(self.cpf_cnpj).valido?
      else
        errors.add(:cpf_cnpj, "CNPJ inválido") unless Cnpj.new(self.cpf_cnpj).valido?
      end
    end
  end

  def validate_destroy
    raise "Este é o usuário Master do sistema, não é possível excluir" if self.is_a?(AdminUser) && AdminUser.master.id == self.id
    raise "Existem transações vinculadas a este usuário" if Transacao.where(cliente_user: self).exists?
    raise "Existem movimentos vinculados a este usuário" if Movimento.where(user: self).exists?
  end

  def before_save
    self.celular = nil if self.celular.to_s.gsub(/\D/, "").blank?
  end

  def validar_celular
    if !self.celular.to_s.blank? && !(self.celular.gsub(/\D/, "") =~ /^\d{2}(9|8|7)/)
      errors.add(:celular, "Número do Celular inválido")
    end
  end
end