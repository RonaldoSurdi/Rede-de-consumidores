require 'test_helper'

class SaldoTest < ActiveSupport::TestCase
  test "saldo total" do
    cliente = users(:cliente)
    assert_equal 64.9,  Saldo.para(cliente).saldo.round(2)
  end

  test "saldo por periodo" do
    cliente = users(:cliente)
    data_inicial = Date.new 2013, 12, 1
    data_final = data_inicial.at_end_of_month
    assert_equal 14.0,  Saldo.para(cliente).no_periodo_de(data_inicial).ate(data_final).saldo.round(2)
  end

  test "tem direito a bonus indicacao" do
    cliente = users(:cliente)
    data_inicial = Date.new 2013, 12, 1
    data_final = data_inicial.at_end_of_month
    assert_not Saldo.para(cliente).no_periodo_de(data_inicial).ate(data_final).tem_direito_bonus_indicacao?

    assert Saldo.para(cliente).tem_direito_bonus_indicacao?
  end
end