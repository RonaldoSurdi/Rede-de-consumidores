class TransacoesController < ApplicationController
  before_filter :authenticate_cliente_user!
  layout "painel"

  def index
    @transacoes = current_cliente_user
              .transacoes
              .joins(operador: :estabelecimento_user)
              .includes(operador: :estabelecimento_user)
              .page(params[:page]).order(created_at: :desc)
  end
end