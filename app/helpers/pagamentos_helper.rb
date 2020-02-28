module PagamentosHelper
  def pessoa(pagamento)
    if pagamento.origem == current_user
      ret = pagamento.destino
    else
      ret = pagamento.origem
    end

    ret.is_a?(AdminUser) ? "Administração" : ret.nome
  end

  def acao(tipo)
    tipo == "PAGAR"  ? "Marcar como Paga" : "Marcar como recebida"
  end
end
