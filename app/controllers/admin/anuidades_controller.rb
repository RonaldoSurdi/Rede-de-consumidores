class Admin::AnuidadesController < Admin::AdminController
  before_filter :set_pagamento, only: [:create]
  def index
    if current_user.is_a?(AdminUser)
      @anuidades = Pagamento
    else
      @anuidades = Pagamento
        .where("destinos_pagamentos.id = ?", current_user)
    end

    @data_inicial = params["data_inicial"].to_s.to_date || Date.today.beginning_of_month
    @data_final = params["data_final"].to_s.to_date || Date.today.end_of_month
    @tipo_data = params["tipo_data"] || "MES_ATUAL"
    @status = params["status"]
    @filter = params[:q]
    @tipo_pagamento = params[:tipo_pagamento]

    @anuidades = @anuidades
                  .joins(:origem, :destino)
                  .includes(:origem, :destino)
                  .page(params[:page])
                  .where("categoria = ?", :anuidade)
                  .where(":status = '' Or :status Is Null Or pagamentos.status = :status", status: @status)
                  .where(":pagamento = '' Or :pagamento Is Null Or pagamentos.tipo_pagamento = :pagamento", pagamento: @tipo_pagamento)
                  .where("users.nome Like :filter Or destinos_pagamentos.nome Like :filter Or nosso_numero like :filter", filter: "%#{@filter}%")
                  .where("pagamentos.created_at >= ?", @data_inicial.at_beginning_of_day)
                  .where("pagamentos.created_at <= ?", @data_final.at_end_of_day)
                  .order("pagamentos.created_at")
  end

  def create
    @pagamento.confirmar_anuidade!
    redirect_to anuidades_path, notice: "Pagamento realizado com sucesso"
  rescue
    redirect_to anuidades_path, alert: "Falha ao realizar pagamento - #{$!}"
  end

  private

  def set_pagamento
    if current_user.is_a?(AdminUser)
    @pagamento = Pagamento.find(params[:id])
    else
      @pagamento = Pagamento.where(destino: current_user).find(params[:id])
    end
  end
end
