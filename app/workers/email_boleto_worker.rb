class EmailBoletoWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  require "boleto_factory"

  def perform(pagamento_id)
    pagamento = Pagamento.find(pagamento_id)
    boleto = BoletoFactory.new(pagamento).gerar
    if pagamento.origem.is_a?(ClienteUser)
      BoletoMailer.send_boleto_cliente(pagamento, boleto).deliver
    else
      BoletoMailer.send_boleto(pagamento, boleto).deliver
    end
  end
end