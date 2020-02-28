require 'test_helper'

class TransacaoTest < ActiveSupport::TestCase
  test "bonus_cliente" do
    assert_equal 0.90, transacoes(:transacao1).bonus_cliente
    assert_equal 6.75, transacoes(:transacao2).bonus_cliente
    assert_equal 4.5, transacoes(:transacao4).bonus_cliente
    assert_equal 4.5, transacoes(:transacao5).bonus_cliente
  end

  test "bonus_indicacao" do
  end
end
