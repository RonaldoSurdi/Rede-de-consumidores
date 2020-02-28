class ConveniadasController < ApplicationController

	def index
    @empresas = EstabelecimentoUser
      .joins(:cities)
      .where(cities: {id: cookies[:cidade_default]})
      .order("nome ASC")
      .to_a
	end

end