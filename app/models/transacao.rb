class Transacao < ActiveRecord::Base
  before_save :gravar_percentual

  @@formas = {
    dinheiro: "Acúmulo",
    pontos: "Resgate"
  }

  @@tipos = {
    dinheiro: "Dinheiro",
    outras: "Outras"
  }

  belongs_to :cliente_user
  belongs_to :operador

  validates_presence_of :cliente_user, :operador, :forma_pagamento, :vlr_gasto, :documento
  validates_presence_of :tipo_pagamento, if: :obrigar_tipo_pagamento?
  validates :vlr_gasto, numericality: { greater_than: 0, less_than: 1000 }
  has_one :movimento

  scope :somar, ->(user, dt_inicial, dt_final) { por_periodo(dt_inicial, dt_final).where(cliente_user: user).where("cancelada = false Or cancelada is null").sum(:vlr_gasto) }
  scope :por_estabelecimento, ->(estabelecimento_user) { where(operador_id: Operador.where(estabelecimento_user_id: estabelecimento_user)) }
  scope :por_periodo, ->(data_inicial, data_final) { where("transacoes.created_at Between ? And ?", data_inicial.at_beginning_of_day, data_final.at_end_of_day) }
  scope :por_franquia, ->(franquia_user) { joins(cliente_user: :cities).where(cities: {id: franquia_user.cities.collect { |c| c.id } }) }

  def vlr_gasto=(vlr_gasto)
    vlr_gasto = vlr_gasto.safe_to_big_decimal if vlr_gasto.is_a? String
    write_attribute(:vlr_gasto, vlr_gasto)
  end

  def self.formas
    @@formas
  end

  def self.tipos
    @@tipos
  end

  def bonus_cliente
    parametrizacao = Parametrizacao.first
    vlr_gasto * (parametrizacao.percentual_cliente.to_f / 100.0) * (percentual_bonus / 100.0)
  end

  def percentual_bonus
    if self.tipo_pagamento.blank? || self.tipo_pagamento.to_sym == :dinheiro
      operador.estabelecimento_user.percentual_bonus.to_f
    else
      operador.estabelecimento_user.percentual_bonus_outras_formas.to_f
    end
  end

  def self.cancelar(id, motivo)
    ActiveRecord::Base.transaction do
      transacao = Transacao.find(id)

      if transacao.movimento
        raise "O movimento não pode ser cancelado" unless transacao.movimento.pode_cancelar?
        raise "O movimento não pode ser cancelado, não há saldo" unless transacao.movimento.tem_saldo_para_cancelar?
        transacao.movimento.destroy!
      end

      transacao.cancelada = true
      transacao.motivo = motivo
      transacao.save!
      EmailMovimentoWorker.perform_async(nil, transacao.id)
      SmsMovimentoWorker.perform_async(nil, transacao.id)
    end
  end

  def self.cancelar_admin(id, motivo)
    ActiveRecord::Base.transaction do
      transacao = Transacao.find(id)

      if transacao.movimento
        raise "O movimento não pode ser cancelado, não há saldo" unless transacao.movimento.tem_saldo_para_cancelar?
        transacao.movimento.destroy!
      end

      transacao.cancelada = true
      transacao.motivo = motivo
      transacao.save!
    end
  end

  def valor_pago_pelo_estabelecimento
    (self.vlr_gasto * (self.percentual_bonus_real / 100.0)).round(2)
  end

  def cliente_user_numero_cartao=(numero_cartao)
    self.cliente_user = ClienteUser.where(numero_cartao: numero_cartao.to_s.gsub(/\D/, "")).first
  end

  def cliente_user_numero_cartao
    cliente_user.numero_cartao if self.cliente_user
  end

  def cliente_user_numero_cartao_formatado
    cliente_user.numero_cartao_formatado if self.cliente_user
  end

  def obrigar_tipo_pagamento?
    self.forma_pagamento.to_sym == :dinheiro
  end

  def gravar_percentual
    self.percentual_bonus_real = self.percentual_bonus unless self.id
  end

  def resgate?
    self.forma_pagamento.to_sym == :pontos
  end

  def acumulo?
    self.forma_pagamento.to_sym == :dinheiro
  end
end