require 'test_helper'

class ClienteUserTest < ActiveSupport::TestCase
  test "gerar codigo do cartao" do
    assert_equal 11001514935000001, users(:cliente3).gerar_codigo_cartao
  end

  test "anuidade paga" do
    assert users(:cliente_anuidade_zerada).anuidade_paga?
    assert_not users(:cliente).anuidade_paga?
  end

  test "numero_cartao_formatado" do
    assert_equal "1 001 000 001", users(:cliente).numero_cartao_formatado
  end
end
