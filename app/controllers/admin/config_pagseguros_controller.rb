class Admin::ConfigPagsegurosController < Admin::AdminController
  before_action :set_config, only: [:index, :show, :edit, :update, :new, :create]

  def index
    render action: :show
  end

  def new
    render action: :edit
  end

  def create
    create_or_update
  end

  def update
    create_or_update
  end

  private

  def set_config
    @config = current_user.config_pagseguro || ConfigPagseguro.new(franquia_user: current_user)
  end

  def config_params
    params.require(:config_pagseguro).permit(:token, :email).merge(franquia_user: current_user)
  end

  def create_or_update
    if @config.update(config_params)
      redirect_to @config, notice: 'Configurações atualizadas com Sucesso.'
    else
      render action: 'edit'
    end
  end
end