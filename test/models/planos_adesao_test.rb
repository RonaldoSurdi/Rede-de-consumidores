require 'test_helper'

class PlanosAdesaoTest < ActiveSupport::TestCase
  test "basico" do
    assert PlanosAdesao.basico 
  end

  test "advanced" do
    assert PlanosAdesao.advanced
  end
end
