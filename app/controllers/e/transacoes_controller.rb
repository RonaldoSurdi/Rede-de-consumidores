class E::TransacoesController < ApplicationController
  before_action :set_transacao, only: [:cancelar, :destroy]
  before_filter :verificar_autenticacao
  layout "e"

  def index
    @filter = params[:q]
    @transacoes = current_operador.transacoes.includes(:cliente_user)
      .where("users.id Like :filter Or users.nome Like :filter Or users.cpf_cnpj Like :filter Or documento Like :filter", filter: "%#{@filter}%").references(:users)
      .order(created_at: :desc)
      .page(params[:page])
  end

  def keep_alive
    render nothing: true
  end

  def new
    @transacao = Transacao.new(vlr_gasto: 0.0)
  end

  def find_cliente
    filter = params[:q]

    @erros = []
    @cliente = ClienteUser.
                where("cpf_cnpj = :filter Or id = :filter Or numero_cartao = :filter", filter: filter.gsub(/\D/, "")).
                first
    @erros << "Cliente não encontrado" unless @cliente
    @erros << "Cliente cadastrado em franquia diferente" if @cliente && !franquia_cities.include?(@cliente.cities[0].id)

    render layout: false
  end

  def create
    ActiveRecord::Base.transaction do
      params_transacao = transacao_params
      @transacao = Transacao.new(params_transacao)
      @transacao.operador = current_operador
      @transacao.save!

      raise "Senha não confere" if @transacao.forma_pagamento.to_sym == :pontos && !@transacao.cliente_user.valid_password?(params[:confirmacao_senha])
      raise "A anuidade do cliente não está paga" if @transacao.forma_pagamento.to_sym == :dinheiro  && !@transacao.cliente_user.anuidade_paga?
      raise "A anuidade do cliente não está paga" if @transacao.forma_pagamento.to_sym == :pontos  && !@transacao.cliente_user.pode_resgatar?


      @movimento = Movimento.gerar_movimento_do_cliente(@transacao)
      @movimento.save!
      redirect_to new_transacao_path, notice: "Transação registrada com sucesso"
    end
  rescue
    @transacao = Transacao.new(transacao_params)
    flash[:alert] = "Falha ao registrar transação #{$!}"
    render action: 'new'
  end

  def cancelar
    render layout: false
  end

  def destroy
    Transacao.cancelar(@transacao.id, params[:motivo])
    redirect_to transacoes_path, notice: "Transacao cancelada com sucesso"
  rescue
    redirect_to transacoes_path, alert: "Falha ao cancelar transação - #{$!}"
  end

  private

  def transacao_params
    params.require(:transacao).permit(:cliente_user_numero_cartao, :vlr_gasto, :forma_pagamento, :documento, :tipo_pagamento)
  end

  def verificar_autenticacao
    redirect_to new_operador_session_path, alert: "Não autorizado" unless current_operador
  end

  def franquia_cities
    FranquiaUser
      .includes(:cities)
      .where("cities_users.city_id In (?)", current_operador.estabelecimento_user.cities)
      .references(:cities)
      .first
      .cities.to_a.collect { |city| city.id }
  end

  def set_transacao
    @transacao = current_operador.transacoes.find(params[:id])
  end
end
