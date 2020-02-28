class Admin::PlanosAdesaoController < Admin::AdminController
  before_action :set_plano, only: [:show, :edit, :update]

  def index
    @planos = PlanosAdesao.all.to_a
  end

  def update
    if @plano.update(plano_params)
      redirect_to @plano, notice: 'Plano alterado com sucesso.'
    else
      render action: 'edit'
    end
  end  

  private

  def set_plano
    @plano = PlanosAdesao.find(params[:id])
  end

  def plano_params
    params.require(:planos_adesao).permit(:vlr_anuidade, :vlr_indicado, :quantidade_indicacoes)
  end

end
