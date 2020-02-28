require "test_helper"

class BannerTest < ActiveSupport::TestCase

  def test_ativos
    scope = Banner.ativos 0
    assert_equal 4, scope.count, "Quantidade de Banners Ativos"
    assert_equal FranquiaUser, scope.last.user.class, "Último deve ser da franquia"
  end

  def test_ativos_logado
    scope = Banner.ativos_da_cidade 0, cities(:getulio)
    assert_equal 3, scope.count, "Quantidade de Banners Ativos Para Getúlio"

    assert_equal AdminUser, scope.first.user.class, "Primeiro deve ser da Admin"
    assert_equal 0, scope.where("users.type = 'FranquiaUser'").count, "Deve zer 0 quantidade de banners do tipo franquia"

    scope = Banner.ativos_da_cidade 0, cities(:erechim)
    assert_equal 4, scope.count, "Quantidade de Banners Ativos Para Erechim"

    assert_equal FranquiaUser, scope.first.user.class, "Primeiro deve ser da Franquia"
  end

end
