class Admin::PasswordController < Admin::AdminController
  def index
    @user = current_user
  end

  def update
    @user = current_user
    valido = current_user.valid_password?(params[:current_password])
    @user.errors.add(:current_password, "A senha atual não confere") unless valido
    if valido && @user.update(password_params) 
      redirect_to password_index_url, notice: "Senha atualizada com sucesso!"
    else
      render :index
    end
  end

  private

  def password_params
    params.require(current_user.class.name.underscore).permit(:password, :password_confirmation)
  end
end