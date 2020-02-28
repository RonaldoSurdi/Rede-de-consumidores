class ErrorsController < ApplicationController
  skip_before_action :confirmation_token
  skip_before_action :verifica_indicante
  skip_before_action :gravar_cookie_com_cidade_do_usuario_logado
  skip_before_action :verifica_cidade_ativa


  def not_found
    render status: 404, layout: false
  end
 
  def unacceptable
    render status: 422, layout: false
  end
 
  def internal_error
    render status: 500, layout: false
  end
end