class ClienteUserRegistrationsController < Devise::RegistrationsController
  include TermoCadastroHelper
  include CookieHelper


  alias :super_new :new
  alias :super_create :create

  before_action :load, only: [:new, :create]
  before_action :verificar_se_termo_foi_aprovado, only: [:new, :create]
  before_action :verificar_indicante, only: [:new, :create]
  layout "painel"

  def new
    if verificar_se_termo_foi_aprovado
      super_new
    end
  end

  def create
    if verificar_se_termo_foi_aprovado
      super_create
    end
  end

  protected

  def after_update_path_for(resource)
    painel_cliente_index_url
  end  

  private

  def load
    @cities = City.somente_cidades_com_franquia.order(:description).to_a
    @planos = PlanosAdesao.order(:descricao).to_a
  end

  def verificar_indicante
    cookie_indicate = indicante
    @padrinho = ClienteUser.find(cookie_indicate[:id].to_i || params[:cliente_user][:padrinho_id]) if cookie_indicate || (params[:cliente_user] && params[:cliente_user][:padrinho_id])
  end

  def verificar_se_termo_foi_aprovado
    if termo_aprovado?
      true
    else
      redirect_to new_termo_cadastro_url
    end
  end
end