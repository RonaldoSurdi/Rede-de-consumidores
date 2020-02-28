class Admin::OperadoresController < Admin::AdminController
  before_action :set_operador, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  def index
    @operadores = current_user.operadores.where('email like :filter Or nome Like :filter', {filter: "%#{params[:q]}%"}).page params[:page]
    @filter = params[:q]
  end

  def show
  end

  def new
    @operador = Operador.new
  end

  def create
    @operador = current_user.operadores.build(operador_params)

    if @operador.save
      redirect_to @operador, notice: 'Operador Criado com Sucesso'
    else
      render action: 'new'
    end
  end

  def update
    p = operador_params

    if p[:password].blank?
      p.delete :password
      p.delete :password_confirmation
    end

    if @operador.update(operador_params)
      redirect_to @operador, notice: 'Operador Atualizado com Sucesso'
    else
      render action: 'edit'
    end
  end

  def destroy
    @operador.destroy
    redirect_to operadores_path
  end

  private

  def set_operador
    @operador = current_user.operadores.find params[:id]
  end

  def operador_params
    params.require(:operador).permit(:email, :password, :password_confirmation, :nome)
  end
end
