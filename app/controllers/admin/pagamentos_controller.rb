class Admin::PagamentosController < Admin::AdminController
  before_filter :set_pagamento, only: [:edit, :show, :confirmar]
  before_filter :carregar_usuarios, only: :index

  def index
    @nosso_numero = params[:nossonumero]
    @tipo = params[:tipo] || "PAGAR"
    @status = params[:status]
    @usuario = params[:usuario] || current_user_unico_admin.id
    validar_usuario!

    @pagamentos = Pagamento.sem_anuidades
                    .joins(:destino)
                    .includes(:origem, :destino)

    if @tipo.to_sym == :PAGAR
      @pagamentos = @pagamentos.where(origem_id: @usuario)
      @pagamentos = @pagamentos.where("status <> ?", "aberto") if @status.to_s == "fechado"
      @pagamentos = @pagamentos.where("status = ?", "aberto") if @status.to_s == "aberto"
    else
      @pagamentos = @pagamentos.where(destino_id: @usuario)
      @pagamentos = @pagamentos.where("recebido", "aberto") if @status.to_s == "fechado"
      @pagamentos = @pagamentos.where("recebido Is Null Or Not recebido", "aberto") if @status.to_s == "aberto"
    end
    @pagamentos = @pagamentos.where("nosso_numero = ?", @nosso_numero) unless @nosso_numero.blank?

    @total = @pagamentos.sum(:valor)
    @pagamentos = @pagamentos.page(params[:page])
  end

  def confirmar
    @pagamento.confirmar! current_user_unico_admin
    redirect_to pagamentos_url, notice: "Operação realizada com sucesso"
  rescue
    redirect_to pagamentos_url, alert: "Falha ao realizar operação"
  end

  private

  def set_pagamento
    @pagamento = Pagamento.find(params[:id])
  end

  def carregar_usuarios
    @usuarios = if current_user.is_a?(AdminUser)
      User.where(type: ["EstabelecimentoUser", "FranquiaUser"]).order(:nome).to_a.collect do |c|
        [c.nome, c.id]
      end << ["Administração", current_user_unico_admin.id]
    elsif current_user.is_a?(FranquiaUser)
      User
        .select("distinct users.id, users.nome")
        .joins(:cities)
        .where(type: ["EstabelecimentoUser"])
        .where(cities: {id: current_user_unico_admin.cities.collect{ |c| c.id }}).order(:nome)
        .to_a.collect do |c|
          [c.nome, c.id]
      end << [current_user_unico_admin.nome, current_user_unico_admin.id]
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