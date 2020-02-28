class Admin::EstabelecimentoUsersController < Admin::AdminController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = EstabelecimentoUser.
        where("nome like ?", "%#{params[:q]}%").
        joins(:cities).where("cities.id in (?)", current_user.cities.to_a).
        page(params[:page])
    @filter = params[:q]
  end

  def new
    load_citites
    @user = EstabelecimentoUser.new(juridica_fisica: :F)
  end

  def edit
    load_citites
  end

  def create
    @user = EstabelecimentoUser.new(user_params)

    if @user.save
      redirect_to @user, notice: "Estabelecimento Criado com Sucesso."
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
    p.delete :city_ids

    if @user.update(p)
      redirect_to @user, notice: "Estabelecimento Atualizado com Sucesso."
    else
      load_citites
      render action: "edit"
    end
  end

  def destroy
    @user.destroy
    redirect_to estabelecimento_users_url, notice: "Registro excluído com sucesso"
  rescue
    redirect_to estabelecimento_users_url, alert: "Falha ao excluir registro - #{$!}"
  end

  private

  def set_user
    @user = EstabelecimentoUser.includes(:cities).where("cities.id in (?)", current_user.cities.to_a).references(:cities).find(params[:id])
  end

  def user_params
    params.require(:estabelecimento_user).permit(:logo, :descricao, :email, :password, :password_confirmation, :nome, :juridica_fisica, :cpf_cnpj, :logradouro, :numero, :bairro, :complemento, :telefone, :celular, :cep, :percentual_bonus, :percentual_bonus_outras_formas, :taxa_publicidade, :url, :observacao, city_ids: [])
  end

  def load_citites
    @cities = current_user.cities.order(:description).to_a
  end
end