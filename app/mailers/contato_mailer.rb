class ContatoMailer < ActionMailer::Base
  default from: "ConsumerCard <no-reply@consumercard.net>"

  def contato(contato)
    logger.info "Enviando e-mail referente ao contato #{contato}"
    @contato = contato
    subject = "Contato via portal ConsumerCard."

    emails = ["contato@consumercard.net", @contato[:email]]
    emails << FranquiaUser.joins(:cities).where("cities.id = ?", contato[:cidade_id]).first.email if contato[:cidade_id]

    mail(
      to: emails.join(";"),
      subject: subject
    )
  end
end