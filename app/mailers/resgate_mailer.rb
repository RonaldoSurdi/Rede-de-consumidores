class ResgateMailer < ActionMailer::Base
  default from: "ConsumerCard <no-reply@consumercard.net>"
  layout "mailer_layout"

  def notificar_envio(resgate)
    @resgate = resgate
    mail(
      to: resgate.cliente_user.email,
      subject: "[ConsumerCard] Seu prêmio foi enviado"
    )
  end
end
