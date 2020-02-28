class Movimento < ActiveRecord::Base
  after_commit :enviar_notificacao, on: [:create]

  before_save :default_values

  belongs_to :user
  belongs_to :transacao

  scope :saldo, ->(user, dt_inicial, dt_final, excluir_fechamentos = false) {
    scope = where(user: user, data: dt_inicial..dt_final)
    scope = scope.where(fechamento_mes_base: nil) if excluir_fechamentos
    scope.sum(:vlr)
  }
  scope :saldo_total, ->(user) { where(user: user).sum(:vlr) }

  validates :user, :vlr, presence: true

  def self.gerar_movimento_do_cliente(transacao)
    ret = Movimento.new

    ret.user = transacao.cliente_user
    ret.transacao = transacao
    if transacao.forma_pagamento.to_sym == :dinheiro
      ret.vlr = transacao.bonus_cliente
      ret.descricao = "Bônus de Compra Própria no Estabelecimento #{transacao.operador.estabelecimento_user.nome}"
    else
      raise "Saldo insuficiente" if Saldo.para(ret.user).saldo < transacao.vlr_gasto
      ret.vlr = -transacao.vlr_gasto
      ret.descricao = "Resgate de Bônus no Estabelecimento #{transacao.operador.estabelecimento_user.nome}"
    end

    ret
  end

  def pode_cancelar?
    if !transacao  || transacao.valor_franquia.nil?
      ultima = Movimento.where(user: user).order(created_at: :desc).first
      ultima.id == self.id
    end
  end

  def tem_saldo_para_cancelar?
    total = Saldo.para(self.user).saldo
    (total - self.vlr.truncate(2)) >= 0
  end

  def vlr=(vlr)
    vlr = vlr.safe_to_big_decimal if vlr.is_a? String
    write_attribute(:vlr, vlr)
  end

  private

  def default_values
    self.data ||= Date.today
  end

  def enviar_notificacao
    if user.is_a? ClienteUser
      EmailMovimentoWorker.perform_async self.id, self.transacao_id
      SmsMovimentoWorker.perform_async self.id, self.transacao_id
    end
  end
end