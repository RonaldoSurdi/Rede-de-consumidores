class Admin::AdminUsersController < Admin::AdminController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = AdminUser.
        where("nome like ?", "%#{params[:q]}%").
        page(params[:page])
    @filter = params[:q]
  end

  def new
    @user = AdminUser.new
  end

  def edit
  end

  def create
    @user = AdminUser.new(user_params)

    if @user.save
      redirect_to @user, notice: 'Usuário Criado com Sucesso.'
    else
      render action: 'new'
    end
  end

  def update
    p = user_params
    if p[:password].blank?
      p.delete :password
      p.delete :password_confirmation
    end

    if @user.update(p)
      redirect_to @user, notice: 'Usuário Atualizado com Sucesso.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url, notice: "Registro excluído com sucesso"
  rescue
    redirect_to admin_users_url, alert: "Falha ao excluir registro - #{$!}"
  end

  private

  def set_user
    @user = AdminUser.find(params[:id])
  end

  def user_params
    params.require(:admin_user).permit(:email, :password, :password_confirmation, :nome)
  end
end