class Admin::IndicacoesAdminController < Admin::AdminController
  before_filter :carregar_usuarios, only: :index

  def index
    condicao = "(Select updated_at From pagamentos Where pagamentos.origem_id = users.id and status = 'pago' Order By id Limit 1) As data_ativacao"
    if params[:usuario].blank?
      @indicacoes = ClienteUser
          .indicacoes
          .order(:nome)

      unless current_user.is_a?(AdminUser)
        @indicacoes = @indicacoes
          .joins(:cities)
          .where(cities: {id: current_user.cities.collect { |c| c.id }})
      end
    else
      @usuario = ClienteUser.find(params[:usuario])
      @indicacoes = ClienteUser.indicacoes(@usuario).order(:nome)
    end
    @sql = @indicacoes.to_sql
  end

  private

  def carregar_usuarios
    @usuarios = if current_user.is_a?(AdminUser)
      User
        .where(type: "ClienteUser")
        .where("Exists (Select 1 From users u where u.padrinho_id = users.id)")
        .order(:nome)
        .to_a.collect do |c|
        [c.nome, c.id]
      end
    elsif current_user.is_a?(FranquiaUser)
      User
        .select("distinct users.id, users.nome")
        .joins(:cities)
        .where(type: "ClienteUser")
        .where("Exists (Select 1 From users u where u.padrinho_id = users.id)")
        .where(cities: {id: current_user_unico_admin.cities.collect{ |c| c.id }}).order(:nome)
        .to_a.collect do |c|
          [c.nome, c.id]
      end
    end
  end

end