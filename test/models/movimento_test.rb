require 'test_helper'

class MovimentoTest < ActiveSupport::TestCase

=begin
  test "gerar_movimento_do_cliente" do
    transacao = transacoes(:transacao1)
    movimento = Movimento.gerar_movimento_do_cliente(transacao)

    assert_not_nil movimento, "Veficando se movimento é null"
  end
=end

  test "pode cancelar?" do
    assert_not movimentos(:movimento5).pode_cancelar?
    assert_not movimentos(:movimento6).pode_cancelar?
    assert movimentos(:movimento7).pode_cancelar?
  end

  test "gerar movimento do cliente" do
    transacao = transacoes(:transacao1)
    m = Movimento.gerar_movimento_do_cliente(transacao)
    assert_equal 0.9, m.vlr
    assert_equal transacao.cliente_user, m.user
    assert_equal transacao, m.transacao
  end

  test "gerar movimento do cliente resgate" do
    transacao = transacoes(:resgate)
    m = Movimento.gerar_movimento_do_cliente(transacao)
    assert_equal -5.0, m.vlr
    assert_equal transacao.cliente_user, m.user
    assert_equal transacao, m.transacao
  end

end