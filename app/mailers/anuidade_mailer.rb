class AnuidadeMailer < ActionMailer::Base
  default from: "ConsumerCard <no-reply@consumercard.net>"
  layout "mailer_layout"

  def confirmacao_pagamento(pagamento)
    logger.info "Enviando e-mail referente a confirmação de pagamento da anuidade"
    @pagamento = pagamento
    mail(
      to: @pagamento.origem.email,
      subject: '[ConsumerCard] Confirmação de Pagamento da Anuidade',
    )
  end
end
