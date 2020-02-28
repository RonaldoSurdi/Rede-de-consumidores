class ApplicationController < ActionController::Base
  require "crypt"
  include CookieHelper
  include ApplicationHelper

  before_action :store_action
  before_action :confirmation_token
  before_action :verifica_indicante
  before_action :gravar_cookie_com_cidade_do_usuario_logado
  before_action :verifica_cidade_ativa

  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def after_sign_out_path_for(resource_or_scope)
    if request.original_url =~ /.+(\/admin).*/
      user_session_url
    elsif resource_or_scope.to_sym == :operador
      new_operador_session_url
    else
      root_url
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    if request.original_url =~ /.+(\/admin).*/
      user_root_url
    elsif resource_or_scope.is_a?(Operador)
      new_transacao_url
    else
      if session[:acao]
        acao = session[:acao]
        session[:acao] = nil
        acao
      else
        painel_cliente_index_url
      end
    end
  end

  def after_update_path_for(resource_or_scope)
    cliente_users_url
  end

  protected

  def configure_permitted_parameters
    params_users = [
      :email, :password, :password_confirmation, :nome, :cpf_cnpj, :logradouro, :numero, :bairro, :complemento, :telefone, :celular, :cep,
      :plano_adesao_id, :padrinho_id, :cidade, :sexo, :estado_civil, :data_nascimento, :juridica_fisica, :razao_social, city_ids: []
    ]

    devise_parameter_sanitizer.for(:sign_up) << params_users
    devise_parameter_sanitizer.for(:account_update) << params_users
  end

  private

  def gravar_cookie_com_cidade_do_usuario_logado
    if current_cliente_user && !scope_admin? && !scope_estabelecimento?
      cidade_usuario = current_cliente_user.cities[0].id
      if cidade_usuario.to_i != cidade_default.to_i
        flash[:notice] = "Você foi automaticamente redirecionado para a cidade de #{City.find(cidade_usuario).description}, faça logout para acessar outra cidade"
        gravar_cidade_default(cidade_usuario)
      end
    end
  end

  def verifica_cidade_ativa
    if !cookies[:cidade_default] && !scope_admin? && !scope_estabelecimento?
      redirect_to home_index_url
    end
  end

  def verifica_indicante
    indicante = params[:indicante]
    if indicante
      gravar_indicante(params[:indicante], params[:email])
      cliente_user = ClienteUser.find(indicante)
      gravar_cidade_default cliente_user.cities[0].id
    end
  end

  def confirmation_token
    original_token = params[:confirmation_token]
    unless original_token.blank?
      cliente_user = ClienteUser.where(confirmation_token: Devise.token_generator.digest(ClienteUser, :confirmation_token, original_token)).first
      gravar_cidade_default cliente_user.cities[0].id if cliente_user
    end
  end

  def store_action
    if params[:acao]
      session[:acao] = if params[:acao] == "indicacao"
        new_indicacao_path
      end
    end
  end
end
