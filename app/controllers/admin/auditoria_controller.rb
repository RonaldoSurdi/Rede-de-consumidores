class Admin::AuditoriaController < Admin::AdminController
  def show
    id = params[:id]
    @descricao = params[:descricao]
    @activities = PublicActivity::Activity
        .select("activities.*, u.nome usuario_nome")
        .joins("Left Join users u On u.id = activities.owner_id")
        .where("activities.key Like ?", "%#{id.underscore}%")
        .where(trackable_id: params[:codigo])
        .order(created_at: :desc)
        .page(params[:page])
  end
end