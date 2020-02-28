class RelatorioTransacoes
  def initialize(transacoes, current_user, total, total_bonus)
    @transacoes = transacoes
    @current_user = current_user
    @total = total
    @total_bonus = total_bonus
  end

  def pdf
    Prawn::Document.new(page_layout: :landscape) do |pdf|
      pdf.fill_color "40464e"
      pdf.text "Relatório de Transações", size: 18, style: :bold, align: :center
      pdf.text "Rede ConsumerCard", size: 12, align: :center

      if @transacoes.to_a.any?
        data = @transacoes.to_a.collect do |transacao|
          row = [
            transacao.id,
            Transacao.formas[transacao.forma_pagamento.to_sym],
            transacao.tipo_pagamento ? Transacao.tipos[transacao.tipo_pagamento.to_sym] : "",
            transacao.documento,
            transacao.operador.nome,
            transacao.created_at.to_s_br,
            transacao.cliente_user.nome,
            transacao.cancelada ? "Sim" : "Não"
          ]

          row << transacao.operador.estabelecimento_user.nome if [AdminUser, FranquiaUser].include? @current_user.class
          row << Dinheiro.new(transacao.vlr_gasto).to_s
          row << Dinheiro.new(transacao.valor_pago_pelo_estabelecimento).to_s
          row
        end
        data += [[
          {content: Dinheiro.new(@total).to_s, colspan: data[0].length-1, font_style: :bold, align: :right},
          {content: Dinheiro.new(@total_bonus).to_s, font_style: :bold, align: :right},
        ]]

        pdf.move_down 30
        pdf.font_size 8
        pdf.table [header] + data, header: true, width: pdf.bounds.width do
          style(row(0..-1), height: 19)
          style(row(0), font_style: :bold)
          style(column(data[0].length-1), align: :right)
          style(column(data[0].length-2), align: :right)
        end
      else
        pdf.move_down 30
        pdf.text "Sem Registros", size: 12
      end

      pdf.move_down 10
      pdf.text "Relatório gerado em #{Time.now.to_s_br}", size: 10, align: :right
    end
  end

  private
  def header
    header = ["#", "Tipo", "Pagamento", "Documento", "Operador", "Data", "Cliente", "Cancelada"]
    header << "Estabelecimento"  if [AdminUser, FranquiaUser].include? @current_user.class
    header << "Vlr.Transação"
    header << "Vlr.Bônus"
  end
end