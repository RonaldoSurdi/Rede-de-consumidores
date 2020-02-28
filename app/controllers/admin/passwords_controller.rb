class Admin::PasswordsController < Devise::PasswordsController

  alias :super_create :create

  def create
    email = params[:user][:email]
    usuario = User.where(email: email).first
    if usuario && usuario.is_a?(ClienteUser)
      redirect_to new_user_password_url, alert: "Email pertence a um Cliente"
    else
      super_create
    end
  end
end