class HomeController < ApplicationController
  include CookieHelper

  layout "inicial"
  
  skip_before_filter :verifica_cidade_ativa

	def index
    if cookies[:cidade_default]
      redirect_to inicio_index_url
    end
		@ufs = {"" => "Selecione um Estado"}.merge UF.somente_com_cidade
	end

  def carregar_cidades
    @cidades = City.somente_cidades_com_franquia.where(uf: params[:uf]).order(:description).to_a unless params[:uf].blank?
  end
  
  def create
    if params[:cidade].blank?
      redirect_to home_index_url
    else 
      gravar_cidade_default params[:cidade]
      cookie_indicante = indicante
      if cookie_indicante
        cliente_user = ClienteUser.find(indicante[:id].to_i)
        deletar_indicante if cliente_user && cliente_user.cities[0].id != params[:cidade].to_i
      end

      redirect_to inicio_index_url
    end
  end
  
  def delete_cidade_default
    cookies.delete :cidade_default
    redirect_to home_index_url
  end
	
end