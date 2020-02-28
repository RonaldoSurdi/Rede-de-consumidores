class IndicacoesController < ApplicationController
  before_filter :authenticate_cliente_user!
  layout "painel"

  def new
    @pessoas_indicadas = ClienteUser.indicacoes(current_cliente_user).order(:nome).to_a
  end

  def create
    params[:emails].split(";").each do |email|
      IndicacaoMailer.indicar(email: email, user: current_cliente_user).deliver unless email.blank?
    end

    redirect_to new_indicacao_url, notice: "Indicações enviadas com sucesso!"
  end
end