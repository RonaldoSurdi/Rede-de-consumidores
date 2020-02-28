class Admin::PremiosController < Admin::AdminController
  before_action :set_premio, only: [:show, :edit, :update, :destroy]
  before_action :load, only: [:new, :create, :edit, :update, :destroy]

  def index
    @premios = Premio
      .where("premios.descricao like :filter Or descricao_completa like :filter Or tipo_usuarios.descricao Like :filter", filter: "%#{params[:q]}%")
      .joins(:tipo_usuario)
      .includes(:tipo_usuario)
      .order(:descricao)
      .page(params[:page])
    @filter = params[:q]
  end

  def new
    @premio = Premio.new
  end

  def create
    @premio = Premio.new(premio_params)

    if @premio.save
      redirect_to @premio, notice: "Prêmio Criado com Sucesso."
    else
      render action: "new"
    end
  end

  def update
    if @premio.update(premio_params)
      redirect_to @premio, notice: "Prêmio Atualizado com Sucesso."
    else
      render action: "edit"
    end
  end

  def destroy
    @premio.destroy
    redirect_to premios_url
  rescue
    redirect_to premios_url, alert: "Falha ao excluir registro - #{$!}"
  end

  private

  def load
    @tipos = TipoUsuario.order(:quantidade_indicacoes).to_a
  end

  def set_premio
    @premio = Premio.find(params[:id])
  end

  def premio_params
    params.require(:premio).permit(:descricao, :descricao_completa, :tipo_usuario_id, :imagem)
  end
end