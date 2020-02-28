class Admin::MovimentosController < Admin::AdminController
  before_filter :carregar_usuarios, only: :index

  def index
    @data_inicial = params["data_inicial"].to_s.to_date || Date.today.beginning_of_month
    @data_final = params["data_final"].to_s.to_date || Date.today.end_of_month
    @tipo_data = params["tipo_data"] || "MES_ATUAL"

    @usuario = params[:usuario] || current_user_unico_admin.id
    validar_usuario!
    if @usuario == "clientes"
      @movimentos = Movimento.joins(:user).where("users.type = 'ClienteUser'") if current_user.is_a? AdminUser

      clientes_franquia = User.select("distinct users.id")
        .joins(:cities)
        .where(type: "ClienteUser")
        .where(cities: {id: current_user_unico_admin.cities.collect{ |c| c.id }})
      @movimentos = Movimento.joins(:user).where("users.id In (#{clientes_franquia.to_sql})") if current_user.is_a? FranquiaUser
    else
      @movimentos = Movimento.where(user_id: @usuario)
    end

    @movimentos = @movimentos.where("data >= ?", @data_inicial) if @data_inicial
    @movimentos = @movimentos.where("data <= ?", @data_final) if @data_final
    @total = @movimentos.sum("vlr")
    @movimentos = @movimentos.page(params[:page])
  rescue
    flash[:alert] = "Verifique as datas digitadas"
  end

  private

  def carregar_usuarios
    @usuarios = if current_user.is_a?(AdminUser)
      User.where(type: ["EstabelecimentoUser", "FranquiaUser", "ClienteUser"]).order(:nome).to_a.collect do |c|
        [c.nome, c.id]
      end << ["Administração", current_user_unico_admin.id] << ["Todos Clientes", "clientes"]
    elsif current_user.is_a?(FranquiaUser)
      User
        .select("distinct users.id, users.nome")
        .joins(:cities)
        .where(type: ["EstabelecimentoUser", "ClienteUser"])
        .where(cities: {id: current_user_unico_admin.cities.collect{ |c| c.id }}).order(:nome)
        .to_a.collect do |c|
          [c.nome, c.id]
      end << [current_user_unico_admin.nome, current_user_unico_admin.id] << ["Todos Clientes", "clientes"]
    else
      []
    end
  end

  def validar_usuario!
    index = @usuarios.index do |k, v|
      v.to_i == @usuario.to_i
    end
    @usuario = current_user_unico_admin.id unless index
  end
end