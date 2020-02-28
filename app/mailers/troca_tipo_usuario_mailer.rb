class TrocaTipoUsuarioMailer < ActionMailer::Base
  default from: "ConsumerCard <no-reply@consumercard.net>"
  layout "mailer_layout"

  def notificar(cliente, tipo)
    @cliente = cliente
    @tipo = tipo

    mail(
      to: @cliente.email,
      subject: "[ConsumerCard] Solicite seu prêmio"
    )
  end
end