module E::TransacoesHelper
  def tr_class(transacao)
    if transacao.cancelada
      "danger"
    end
  end

  def exibir_cancelamento?(transacao)
    transacao.valor_franquia.nil? && !transacao.cancelada && transacao.created_at.to_date == DateTime.now.to_date
  end

  def exibir_cancelamento_admin?(transacao)
    transacao.valor_franquia.nil? && !transacao.cancelada
  end
end