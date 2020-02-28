class ResgatesController < ApplicationController
  before_filter :authenticate_cliente_user!
  layout "painel"

  def index
    @premios = premios_disponiveis.to_a
    @consumo_medio_mensal = current_cliente_user.consumo_medio_mensal(6).to_f
    @limite = @consumo_medio_mensal >= Parametrizacao.first.vlr_consumo_medio_para_resgate_premios.to_f
    maximo_ja_resgatado = Resgate.where(cliente_user: current_cliente_user).joins({premio: :tipo_usuario}).maximum("tipo_usuarios.quantidade_indicacoes").to_i
    @proximo = TipoUsuario.where("quantidade_indicacoes > ?", current_cliente_user.quantidade_indicacoes).first
  end

  def new
    valido = premios_disponiveis.where("premios.id = ?", params[:id].to_i).exists?
    if valido
      @premio = Premio.find(params[:id])
    else
      redirect_to resgates_url, alert: "Prêmio não disponível para você."
    end
  end

  def create
    valido = premios_disponiveis.where("premios.id = ?", params[:premio_id].to_i).exists?
    limite = current_cliente_user.consumo_medio_mensal(6).to_f >= Parametrizacao.first.vlr_consumo_medio_para_resgate_premios.to_f

    raise "Prêmio inválido" unless valido
    raise "Não atingiu limite" unless limite

    ActiveRecord::Base.transaction do
      current_cliente_user.update! cliente_user_params
      Resgate.create! cliente_user: current_cliente_user, premio_id: params[:premio_id].to_i, enviado: false
    end
    redirect_to painel_cliente_index_url, notice: "Quando o prêmio for enviado para o seu endereço, você receberá um e-mail com a confirmação"
  end

  private

  def premios_disponiveis
    Premio.premios_disponiveis_usuario(current_cliente_user)
      .includes(:tipo_usuario)
      .order(:tipo_usuario_id)
  end

  def cliente_user_params
    params.require(:cliente_user).permit(:cep, :cidade, :logradouro, :numero, :bairro, :complemento)
  end
end