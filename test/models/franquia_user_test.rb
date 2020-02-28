require 'test_helper'

class FranquiaUserTest < ActiveSupport::TestCase
  test "gravar franquia sem cidades" do
    u = users(:franquia_1)
    saved = u.save
    assert u.errors.messages.any?
    assert_not saved

    u.cities = [City.first]
    assert u.save
  end

  test "gravar franquias na mesma cidade" do
    u = users(:franquia_1)
    u.cities = [City.first]
    assert u.save

    u = users(:franquia_2)
    u.cities = [City.first]
    saved = u.save
    assert u.errors.messages.any?
    assert_not saved

    u = users(:franquia_3)
    u.cities = [City.last]
    assert u.save
  end
end
