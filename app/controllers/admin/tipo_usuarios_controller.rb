class Admin::TipoUsuariosController < Admin::AdminController
  before_action :set_tipo, only: [:show, :edit, :update, :destroy]

  def index
    @tipos = TipoUsuario
      .where("descricao like ?", "%#{params[:q]}%")
      .order(:quantidade_indicacoes)
      .page(params[:page])
    @filter = params[:q]
  end

  def new
    @tipo = TipoUsuario.new
  end

  def create
    @tipo = TipoUsuario.new(tipo_params)

    if @tipo.save
      redirect_to @tipo, notice: 'Tipo de Usuário Criado com Sucesso.'
    else
      render action: 'new'
    end
  end

  def update
    if @tipo.update(tipo_params)
      redirect_to @tipo, notice: 'Tipo de Usuário Atualizado com Sucesso.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @tipo.destroy
    redirect_to tipo_usuarios_url
  rescue
    redirect_to tipo_usuarios_url, alert: "Falha ao excluir registro - #{$!}"
  end  

  private

  def set_tipo
    @tipo = TipoUsuario.find(params[:id])
  end

  def tipo_params
    params.require(:tipo_usuario).permit(:descricao, :quantidade_indicacoes, :imagem)
  end
end