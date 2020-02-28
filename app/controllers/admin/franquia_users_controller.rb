class Admin::FranquiaUsersController < Admin::AdminController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = FranquiaUser.
        where("nome like ?", "%#{params[:q]}%").
        page(params[:page])
    @filter = params[:q]
  end

  def new
    load_citites
    @user = FranquiaUser.new(juridica_fisica: :F)
  end

  def edit
    load_citites
  end

  def create
    @user = FranquiaUser.new(user_params)

    if @user.save
      redirect_to @user, notice: "Franquia Criada com Sucesso."
    else
      load_citites
      render action: "new"
    end
  end

  def update
    p = user_params
    if p[:password].to_s.blank?
      p.delete :password
      p.delete :password_confirmation
    end
    p[:city_ids] ||= []

    if @user.update(p)
      redirect_to @user, notice: "Franquia Atualizada com Sucesso."
    else
      load_citites
      render action: "edit"
    end
  end

  def destroy
    @user.destroy
    redirect_to franquia_users_url, notice: "Registro excluído com sucesso"
  rescue
    redirect_to franquia_users_url, alert: "Falha ao excluir registro - #{$!}"
  end

  private

  def set_user
    @user = FranquiaUser.find(params[:id])
  end

  def user_params
    params.require(:franquia_user).permit(:email, :password, :password_confirmation, :nome, :juridica_fisica, :cpf_cnpj, :logradouro, :numero, :bairro, :complemento, :telefone, :celular, :cep, city_ids: [])
  end

  def load_citites
    @cities = City.order(:description).to_a
  end
end