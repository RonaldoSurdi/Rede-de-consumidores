module ConveniadasHelper
  def bonus_cliente(estabelecimento)
    estabelecimento.percentual_bonus.to_f * (Parametrizacao.first.percentual_cliente.to_f / 100.0)
  end

  def bonus_indicacao(estabelecimento)
    estabelecimento.percentual_bonus.to_f * (Parametrizacao.first.percentual_indicado.to_f / 100.0)
  end

  def bonus_cliente_outros(estabelecimento)
    estabelecimento.percentual_bonus_outras_formas.to_f * (Parametrizacao.first.percentual_cliente.to_f / 100.0)
  end

  def bonus_indicacao_outros(estabelecimento)
    estabelecimento.percentual_bonus_outras_formas.to_f * (Parametrizacao.first.percentual_indicado.to_f / 100.0)
  end
end