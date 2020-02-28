class Admin::ClienteUsersController < Admin::AdminController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :emitir_cartao]
  before_action :load, only: [:show, :edit, :update, :create, :new]

  def index
    @users = ClienteUser.
        select("users.*, planos_adesoes.descricao plano, Concat(cities.description, ' - ', cities.uf) cidade").
        select("(Select updated_at From pagamentos p Where p.categoria = 'anuidade' And p.status = 'pago' And p.origem_id = users.id Order By updated_at Limit 1) ultimo_pagamento").
        joins(:plano_adesao, :cities).
        where("email = :filterNaoLike Or nome like :filter Or planos_adesoes.descricao Like :filter Or numero_cartao = :filterNaoLike Or cpf_cnpj Like :filter Or cities.description Like :filter", filter: "%#{params[:q]}%", filterNaoLike: params[:q].to_s.gsub(/\s+/, "")).
        order("date(ultimo_pagamento), users.nome").
        page(params[:page])


    unless params[:cartao_emitido].blank?
      @cartao_emitido = params[:cartao_emitido].to_s == "true" ? true : false
      @users = @users.where(cartao_emitido: @cartao_emitido)
    end

    if current_user.is_a? FranquiaUser
      @users = @users.where(cities: {id: current_user.cities.collect { |c| c.id }})
    end

    @filter = params[:q]
  end

  def new
    @user = ClienteUser.new plano_adesao: PlanosAdesao.pessoal.first
  end

  def create
    @user = ClienteUser.new(user_params)

    if @user.save
      redirect_to cliente_user_path(@user), notice: "Cliente Criado com Sucesso."
    else
      render action: "new"
    end
  end

  def update
    p = user_params
    if p[:password].to_s.blank?
      p.delete :password
      p.delete :password_confirmation
    end
    p.delete(:city_ids)
    if @user.update(p)
      redirect_to @user, notice: "Cliente Atualizado com Sucesso."
    else
      render action: "edit"
    end
  end

  def destroy
    @user.destroy
    redirect_to cliente_users_url, notice: "Registro excluído com sucesso"
  rescue
    redirect_to cliente_users_url, alert: "Falha ao excluir registro - #{$!}"
  end

  def emitir_cartao
    @user.cartao_emitido = true
    if @user.save
      redirect_to cliente_users_url, notice: "Operação realizada com sucesso."
    else
      redirect_to cliente_users_url, alert: "Falha ao realizar operação - #{@user.errors.messages}"
    end
  end

  def anuidade_paga?
    raise "Cliente ainda não registrado" unless self.id

    Pagamentos.where(origem: self, status: :pago).where("updated_at >= ?", Date.today)
  end

  private

  def set_user
    @user = ClienteUser.find(params[:id])
  end

  def load
    if current_user.is_a? AdminUser
      @cities = City.somente_cidades_com_franquia.order(:description).to_a
    else
      @cities = current_user.cities.order(:description).to_a
    end

    @planos = PlanosAdesao.order(:descricao).to_a

    if @user && @user.id
      franquia = @user.franquia
      cities = franquia.cities.collect{ |city| city.id}
      @users = ClienteUser.order(:nome).joins(:cities).where(cities: {id:cities}).where.not(users: {id: @user.id}).to_a
    end
  end

  def user_params
    params.
      require(:cliente_user).
      permit(:email, :password, :password_confirmation, :nome, :juridica_fisica, :cpf_cnpj, :logradouro, :numero, :bairro, :complemento, :telefone,
              :celular, :cep, :plano_adesao_id, :padrinho_id, :cidade, :sexo, :estado_civil, :data_nascimento, :razao_social, city_ids: [])
  end
end