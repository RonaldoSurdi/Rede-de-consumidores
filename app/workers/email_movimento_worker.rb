class EmailMovimentoWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(movimento_id, transacao_id)
    movimento = Movimento.find(movimento_id) if movimento_id
    transacao = Transacao.find(transacao_id) if transacao_id
    MovimentoMailer.notificacao(movimento, transacao).deliver
  end
end