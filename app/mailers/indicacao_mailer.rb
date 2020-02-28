class IndicacaoMailer < ActionMailer::Base
  default from: "ConsumerCard <no-reply@consumercard.net>"
  layout "mailer_layout"

  def indicar(indicacao)
    @indicacao = indicacao
    subject = "Você foi indicado para participar da Rede ConsumerCard"
    mail(
      to: indicacao[:email],
      subject: subject
    )
  end
end
