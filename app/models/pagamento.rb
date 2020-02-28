class Pagamento < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller ? controller.current_user || controller.current_cliente_user : nil }

  before_save :default_values
  after_commit :enviar_email_assinc, on: :create

  @@status = {
    aberto: "Aberto",
    aguardando: "Aguardando Pagamento",
    pago: "Pago"
  }

  @@tipos = {
    boleto: "Boleto Bancário",
    pag_seguro: "PagSeguro (Cartão de Crédito)"
  }

  @@categorias = {
    diversos: "Diversos",
    anuidade: "Anuidade",
    cartao: "Cartão"
  }

  belongs_to :origem, class_name: User
  belongs_to :destino, class_name: User
  belongs_to :planos_adesao
  validates :origem, :destino, :valor, presence: true
  scope :sem_anuidades, -> { joins(:origem).where.not(categoria: :anuidade) }

  def self.status
    @@status
  end

  def self.tipos
    @@tipos
  end

  def confirmar!(usuario_corrente)
    ActiveRecord::Base.transaction do
      if usuario_corrente.id == self.origem.id
        self.status = :pago
      else
        self.recebido = true
      end
      self.save!

      if self.categoria.to_sym == :cartao
        Movimento.create!({
          vlr: self.valor,
          user: self.destino,
          descricao: "Pagamento da taxa de segunda via do cartão de #{self.origem.nome}"
        })
      end
    end
  end

  def confirmar_anuidade!(valor_indicacao = nil, pontos_indicacao = nil)
    Rails.logger.info "Confirmando anuidade #{valor_indicacao} #{pontos_indicacao}".green
    ActiveRecord::Base.transaction do
      self.status = :pago
      self.save!

      valor_indicado = 0.0
      valor_franquia = self.valor
      padrinho = self.origem.padrinho
      if padrinho
        quantidade_indicacoes = padrinho.quantidade_indicacoes.to_i

        valor_indicado = if padrinho.plano_adesao.advanced? && self.planos_adesao.advanced?
          plano = PlanosAdesao.advanced
          quantidade_indicacoes += pontos_indicacao || plano.quantidade_indicacoes
          valor_indicacao || plano.vlr_indicado
        else
          plano = PlanosAdesao.basico
          quantidade_indicacoes += pontos_indicacao || plano.quantidade_indicacoes
          valor_indicacao || plano.vlr_indicado
        end

        padrinho.update! quantidade_indicacoes: quantidade_indicacoes
      end

      if valor_indicado.to_f > 0
        movimento = Movimento.new
        movimento.vlr = valor_indicado
        movimento.user = self.origem.padrinho
        movimento.descricao = "Bônus de Indicação de #{self.origem.nome}"
        movimento.save!
      end

      valor_para_franquia = valor_franquia - valor_indicado.to_f
      if valor_para_franquia.to_f > 0
        movimento = Movimento.new
        movimento.vlr = valor_franquia - valor_indicado.to_f
        movimento.user = self.destino
        movimento.descricao = "Pagamento da Anuidade de #{self.origem.nome}"
        movimento.save!
      end
    end

    Thread.new do
      TrocaTipoUsuarioWorker.perform_async(self.origem.padrinho.id) if self.origem.padrinho
      AnuidadeMailer.confirmacao_pagamento(self).deliver
      unless self.origem.celular.blank?
        require "sms_sender"
        SmsSender.new(self.origem.celular, "[ConsumerCard] O pagamento de sua anuidade foi confirmado. Parabens por se tornar um consumidor inteligente ConsumerCard.").send
      end
    end
  end

  def self.gerar_anuidade!(cliente_user, plano_adesao, tipo_pagamento, valor = nil)
    plano_adesao = PlanosAdesao.find(plano_adesao.to_i) unless plano_adesao.is_a? PlanosAdesao
    ActiveRecord::Base.transaction do
      pagamento_em_aberto = Pagamento.where(origem: cliente_user, status: :aguardando, categoria: :anuidade).first
      pagamento_em_aberto.destroy! if pagamento_em_aberto

      cliente_user.update!(plano_adesao_id: plano_adesao.id)
      valor_anuidade = valor || plano_adesao.vlr_anuidade
      pagamento = Pagamento.new({
        status: :aguardando,
        origem: cliente_user,
        destino: cliente_user.franquia,
        tipo_pagamento: tipo_pagamento,
        valor: valor_anuidade,
        planos_adesao: plano_adesao,
        categoria: :anuidade
      })
      pagamento.save!
      pagamento
    end
  end

  private

  def default_values
    self.status ||= :aberto
    self.data_vencimento ||= Date.today + self.destino.config_boleto.dias_vencimento.day if self.destino.config_boleto
    self.tipo_pagamento ||= :boleto
    self.categoria ||= :diversos
  end

  def enviar_email_assinc
    EmailBoletoWorker.perform_async self.id if self.data_vencimento && self.tipo_pagamento.to_sym == :boleto && self.categoria.to_s != "cartao" && self.valor.to_f > 0
  end
end