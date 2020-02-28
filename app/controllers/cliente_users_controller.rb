class ClienteUsersController < ApplicationController
  before_filter :authenticate_cliente_user!

  layout "painel"

  def index
    @consumo_medio_mensal = current_cliente_user.consumo_medio_mensal(6).to_f
  end
end
