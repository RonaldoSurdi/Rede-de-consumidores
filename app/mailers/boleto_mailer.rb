class BoletoMailer < ActionMailer::Base
  default from: "ConsumerCard <no-reply@consumercard.net>"
  layout "mailer_layout"

  def send_boleto(pagamento, boleto)
    logger.info "Enviando e-mail referente ao pagamento ##{pagamento.id}"
    @pagamento = pagamento
    @boleto = boleto
    attachments["Boleto-#{boleto.numero_documento}.pdf"] = boleto.to_pdf
    mail(
      to: @pagamento.origem.email,
      subject: '[ConsumerCard] Boleto de Cobrança',
    )
  end

  def send_boleto_cliente(pagamento, boleto)
    logger.info "Enviando e-mail referente ao pagamento ##{pagamento.id}"
    @pagamento = pagamento
    @boleto = boleto
    attachments["Boleto-#{boleto.numero_documento}.pdf"] = boleto.to_pdf
    mail(
      to: @pagamento.origem.email,
      subject: '[ConsumerCard] Boleto de Cobrança da Anuidade',
    )
  end
end
