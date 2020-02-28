class InicioController < ApplicationController
  include ApplicationHelper

  def index
    @banners = Banner.ativos_da_cidade(0, current_cidade).to_a
    @empresas = EstabelecimentoUser.joins(:cities).where(cities: {id: cookies[:cidade_default]}).limit(3).order("RAND()").to_a
    @banners_tipo_2 = Banner.ativos_da_cidade(1, current_cidade).limit(1).to_a
  end

end