require "test_helper"

class StringTest < ActiveSupport::TestCase

  def test_safe_to_f
    input = "R$ 1.000.000,10"
    f = input.safe_to_f

    assert f.is_a? Float
    assert_equal 1000000.10, f 
  end

  def test_remover_acentos
    assert_equal "aeiou TESTE AEIOUcC AaEe", "ãéíóú TESTE ÁÉÍÓÚçÇ ÃãÊê".remover_acentos
    assert_equal "", "".remover_acentos
  end

end 