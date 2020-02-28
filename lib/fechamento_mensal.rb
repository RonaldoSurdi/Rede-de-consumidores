class FechamentoMensal

  def self.do(mes, ano)
    data = "01/#{mes}/#{ano}".to_date

    raise "Movimento já foi processado para o Mês #{mes} do ano #{ano}" if Transacao.por_periodo(data.at_beginning_of_month, data.at_end_of_month).where.not(valor_franquia: nil).count > 0
    raise "Não existe Movimento para o Mês #{mes} do ano #{ano}" if Transacao.por_periodo(data.at_beginning_of_month, data.at_end_of_month).count == 0

    ActiveRecord::Base.transaction do
      Fechamentos.new.do(data)
      GeradorPagamentos.new(data + 1.month).gerar!
    end
  end
end