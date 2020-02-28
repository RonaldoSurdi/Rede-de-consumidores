class Resgate < ActiveRecord::Base
  belongs_to :cliente_user
  belongs_to :premio
  after_commit :enviar_email_confirmacao


  def enviar_email_confirmacao
    if self.enviado
      ResgateMailer.notificar_envio(self).deliver
      sms = "[ConsumerCard] Seu prêmio #{self.premio.descricao} acaba de ser enviado para voce. Ele chegara no seu endereço em até #{Parametrizacao.first.prazo_entrega_premio} dias."
      SmsSender.new(self.cliente_user.celular, sms).send
    end
  end
end