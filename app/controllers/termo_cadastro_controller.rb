class TermoCadastroController < ApplicationController
  include TermoCadastroHelper

  def new
    @painel = params[:painel].to_s == "true"
    render "painel", layout: "painel" if @painel
  end

  def create
    aprovar_termo!
    redirect_to new_registration_url(:cliente_user)
  end

  def destroy
    rejeitar_termo!
    redirect_to root_path
  end

end