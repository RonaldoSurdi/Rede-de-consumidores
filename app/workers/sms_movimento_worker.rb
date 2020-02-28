class SmsMovimentoWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(movimento_id, transacao_id)
    require "sms_sender"

    movimento = Movimento.find(movimento_id) if movimento_id
    transacao = Transacao.find(transacao_id) if transacao_id

    cliente_user = transacao ? transacao.cliente_user : movimento.user
    telefone = cliente_user.celular

    unless telefone.blank?
      mensagem = if transacao
        montar_mensagem_transacao(transacao)
      else
        montar_mensagem_movimento(movimento)
      end

      SmsSender.new(telefone, mensagem).send
    end
  end

  def montar_mensagem_movimento(movimento)
    "[ConsumerCard] Movimentação em sua conta. Valor: #{Dinheiro.new(movimento.vlr.truncate(2)).to_s} reais, #{movimento.descricao}."
  end

  def montar_mensagem_transacao(transacao)
    estabelecimento = "#{transacao.operador.estabelecimento_user.nome}"

    if transacao.forma_pagamento.to_sym == :dinheiro
     if transacao.cancelada
        "[ConsumerCard] Cancelamento da transação ##{transacao.id}. Valor Gasto: #{Dinheiro.new(transacao.vlr_gasto.truncate(2)).to_s} reais, #{estabelecimento}."
      else
        "[ConsumerCard] Registro da transação ##{transacao.id}. Valor Gasto: #{Dinheiro.new(transacao.vlr_gasto.truncate(2)).to_s} reais, bônus acumulado: #{Dinheiro.new(transacao.movimento.vlr.truncate(2)).to_s} reais, #{estabelecimento}."
      end
    else
      if transacao.cancelada
        "[ConsumerCard] Cancelamento da transação ##{transacao.id}, referente ao resgate de #{Dinheiro.new(transacao.vlr_gasto.truncate(2)).to_s} reais, #{estabelecimento}."
      else
        "[ConsumerCard] Registro da transação ##{transacao.id}. Valor resgatado: #{Dinheiro.new(transacao.vlr_gasto.truncate(2)).to_s} reais, #{estabelecimento}."
      end
    end
  end
end