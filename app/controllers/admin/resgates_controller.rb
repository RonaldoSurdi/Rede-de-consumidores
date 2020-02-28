class Admin::ResgatesController < Admin::AdminController
  before_action :set_resgate, only: [:edit, :update]

  def index
    @filter = params[:q]
    @enviado = params[:enviado] || "nao"

    @resgates = Resgate
      .where("users.nome like :filter Or premios.descricao Like :filter", {filter: "%#{@filter}%"})
      .where(":enviado = '' Or (:enviado = 'sim' And enviado) Or (:enviado = 'nao' And Not enviado)", {enviado: @enviado.to_s})
      .joins(:premio, :cliente_user)
      .includes(:premio, :cliente_user)
      .includes({premio: :tipo_usuario})
      .order(:id)
      .page(params[:page])
  end

  def update
    @resgate.update enviado: true
    redirect_to resgate_admin_index_url, notice: "Prêmio enviado"
  end

  private

  def set_resgate
    @resgate = Resgate.find(params[:id])
  end
end