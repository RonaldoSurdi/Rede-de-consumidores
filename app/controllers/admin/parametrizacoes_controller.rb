class Admin::ParametrizacoesController < Admin::AdminController
  before_action :set_config, only: [:show, :edit, :update]
  before_filter :authenticate_user!

  def index
    redirect_to parametrizacao_path(Parametrizacao.first.id)
  end

  def edit
  end

  def show
  end

  def update
    @parametrizacao = Parametrizacao.first
    if @parametrizacao.update(parametrizacao_params)
      redirect_to @parametrizacao, notice: 'Configurações atualizadas com Sucesso.'
    else
      render action: 'edit'
    end
  end

  private

  def parametrizacao_params
    params.require(:parametrizacao).permit(:percentual_indicado, :percentual_franquia, :percentual_cliente, :vlr_minimo_bonus_indicacao, :percentual_administracao, :vlr_consumo_medio_para_resgate_premios, :prazo_entrega_premio, :valor_cartao)
  end

  def set_config
    @parametrizacao = Parametrizacao.find params[:id]
  end
end