class CartaoMailer < ActionMailer::Base
  default from: "ConsumerCard <no-reply@consumercard.net>"
  layout "mailer_layout"

  def send_boleto_cliente(pagamento, boleto)
    @pagamento = pagamento
    @boleto = boleto
    attachments["Boleto-#{boleto.numero_documento}.pdf"] = boleto.to_pdf

    mail(
      to: @pagamento.origem.email,
      subject: "[ConsumerCard] Boleto de Cobrança da 2ª via do cartão"
    )
  end

  def send_informacoes_to_admin(pagamento)
    @pagamento = pagamento

    mail(
      to: AdminUser.master.email,
      subject: "#{pagamento.origem.nome} solicitou 2ª via do cartão"
    )
  end
end
