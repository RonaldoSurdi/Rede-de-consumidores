class Admin::CitiesController < Admin::AdminController
  before_action :set_city, only: [:show, :edit, :update, :destroy]

  def index
    @cities = City.where('description like :filter Or uf Like :filter', {filter: "%#{params[:q]}%"}).page params[:page]
    @filter = params[:q]
  end

  def show
  end

  def new
    @city = City.new
    @uf = UF.all
  end

  def edit
    @uf = UF.all
  end

  def create
    @city = City.new(city_params)

    if @city.save
      redirect_to @city, notice: 'Cidade Criada com Sucesso.'
    else
      render action: 'new'
    end
  end

  def update
    if @city.update(city_params)
      redirect_to @city, notice: 'Cidade Atualizada com Sucesso.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @city.destroy
    redirect_to cities_url
  rescue
    redirect_to cities_url, alert: "Falha ao excluir registro - #{$!}"
  end

  private
    def set_city
      @city = City.friendly.find(params[:id])
    end

    def city_params
      params.require(:city).permit(:description, :uf)
    end
end