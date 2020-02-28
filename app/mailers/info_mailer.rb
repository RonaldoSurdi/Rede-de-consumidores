class InfoMailer < ActionMailer::Base
  default from: "ConsumerCard <no-reply@consumercard.net>"

  def informar(mensagens, assunto)
    @mensagens = mensagens
    mail(
      to: "hostmaster@consumercard.net",
      subject: assunto
    )
  end
end
