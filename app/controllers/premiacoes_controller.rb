class PremiacoesController < ApplicationController
  before_action :set_premio, only: [:show]

  def index
    @tipos = TipoUsuario
      .order(:quantidade_indicacoes)
	end

  private

  def set_premio
    @premio = Premio.find(params[:id])
  end
end