class GeradorPagamentos

  def initialize(data_base)
    @data_inicial = data_base.to_date.at_beginning_of_month
    @data_final = data_base.to_date.at_end_of_month
  end

  def gerar!
    totais = Movimento
              .select("Sum(vlr) vlr, users.id user_id")
              .joins(:user)
              .where(transacao_id: nil, users: {type: "EstabelecimentoUser"})
              .where(data: @data_inicial..@data_final)
              .group("users.id")
              .having("Sum(Vlr) != 0")

    totais.to_a.each do |total|
      pagamento = Pagamento.new
      pagamento.valor = total.vlr.abs.truncate(2)
      if total.vlr > 0
        pagamento.origem = total.user.franquia
        pagamento.destino = total.user
      else
        pagamento.origem = total.user
        pagamento.destino = total.user.franquia
      end
      pagamento.save!
    end
  end
end