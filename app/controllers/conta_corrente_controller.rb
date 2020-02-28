class ContaCorrenteController < ApplicationController
  before_filter :authenticate_cliente_user!
  layout "painel"

  def index
    @movimentos = current_cliente_user
              .movimentos
              .page(params[:page]).order(data: :desc)
  end
end