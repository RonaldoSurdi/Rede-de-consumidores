class Admin::BannersController < Admin::AdminController
  before_action :set_banner, only: [:show, :edit, :update, :destroy]

  def index
    @banners = current_user_unico_admin.banners.where('descricao like :filter Or url Like :filter', {filter: "%#{params[:q]}%"}).page params[:page]
    @filter = params[:q]
  end

  def new
    @banner = Banner.new
  end

  def create
    @banner = Banner.new(banner_params)
    @banner.user = current_user_unico_admin

    if @banner.save
      redirect_to @banner, notice: 'Banner Criado com Sucesso.'
    else
      render action: 'new'
    end
  end

  def update
    update_params = banner_params
    update_params.delete(:tipo)
    if @banner.update(update_params)
      redirect_to @banner, notice: 'Banner Atualizado com Sucesso.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @banner.destroy
    redirect_to banners_url
  rescue
    redirect_to banners_url, alert: "Falha ao excluir registro - #{$!}"
  end

  private
    def set_banner
      @banner = current_user_unico_admin.banners.find(params[:id])
    end

    def banner_params
      params.require(:banner).permit(:descricao, :url, :data_inicial_str, :data_final_str, :file, :tipo)
    end
end