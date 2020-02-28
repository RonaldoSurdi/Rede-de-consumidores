class TrocaTipoUsuarioWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(usuario_id)
    @cliente = ClienteUser.find(usuario_id)
    @tipo = TipoUsuario.where(quantidade_indicacoes: @cliente.quantidade_indicacoes).first
    if @tipo
      sms = "[ConsumerCard] Parabens! Você acaba de se tornar um #{@tipo.descricao}. Acesse seu painel no site e veja como solicitar seu prêmio."
      SmsSender.new(@cliente.celular, sms).send
      TrocaTipoUsuarioMailer.notificar(@cliente, @tipo).deliver
    end
  end
end