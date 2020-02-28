class MovimentoMailer < ActionMailer::Base
  default from: "ConsumerCard <no-reply@consumercard.net>"
  layout "mailer_layout"

  def notificacao(movimento, transacao)
    @movimento = movimento
    @transacao = transacao
    @cliente_user = movimento ? movimento.user : transacao.cliente_user

    subject = "[ConsumerCard] Movimentação em sua conta"
    mail(
      to: @cliente_user.email,
      subject: subject
    )
  end
end
