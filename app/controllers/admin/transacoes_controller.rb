class Admin::TransacoesController < Admin::AdminController
  before_action :set_transacao, only: [:cancelar, :destroy]
  before_action :set_query, only: [:index, :pdf]
  before_filter :authenticate_user!

  def index
    pdf if params[:pdf]
    @transacoes = @transacoes.page(params[:page])
  end

  def cancelar
    render layout: false
  end

  def destroy
    Transacao.cancelar_admin(@transacao.id, params[:motivo])
    redirect_to admin_transacoes_path, notice: "Transacao cancelada com sucesso"
  rescue
    redirect_to admin_transacoes_path, alert: "Falha ao cancelar transação - #{$!}"
  end

  def pdf
    relatorio = RelatorioTransacoes.new(@transacoes, current_user, @total, @total_bonus)
    send_data relatorio.pdf.render, type: "application/pdf", filename: "transacoes.pdf"
  end

  private
    
  def set_transacao
    @transacao = Transacao.por_estabelecimento(current_user).find(params[:id])
  end

  def set_query
    @data_inicial = params["data_inicial"].to_s.to_date || Date.today.beginning_of_month
    @data_final = params["data_final"].to_s.to_date || Date.today.end_of_month
    @tipo_data = params["tipo_data"] || "MES_ATUAL"
    @exibir_canceladas = params["exibir_canceladas"] || "N"
    @filter = params[:q]
    @tipo_operacao = params[:tipo_operacao]
    @estabelecimento_id = current_user.is_a?(EstabelecimentoUser) ? current_user.id : params[:estabelecimento_id]
    @estabelecimentos = EstabelecimentoUser.order(:nome).to_a if current_user.is_a? AdminUser
    @estabelecimentos = EstabelecimentoUser.joins(:cities).where("cities.id in (?)", current_user.cities.to_a).order(:nome).to_a if current_user.is_a? FranquiaUser

    @transacoes = Transacao.por_estabelecimento(@estabelecimento_id) unless @estabelecimento_id.blank?
    @transacoes = Transacao.por_franquia(current_user) if current_user.is_a? FranquiaUser
    @transacoes = (@transacoes || Transacao)
                    .joins(:operador, :cliente_user)
                    .includes(:operador, :cliente_user, operador: :estabelecimento_user)
                    .where("transacoes.id = :filter_sem_like Or transacoes.tipo_pagamento = :filter_sem_like Or operadores.nome like :filter Or users.nome Like :filter Or users.numero_cartao = :filter_sem_like", filter: "%#{params[:q]}%", filter_sem_like: params[:q])
                    .where("forma_pagamento like :filter", filter: "%#{params[:tipo_operacao]}%")
                    .where("transacoes.created_at >= ?", @data_inicial.at_beginning_of_day)
                    .where("transacoes.created_at <= ?", @data_final.at_end_of_day)
                    .order(created_at: :desc)
    @transacoes = @transacoes.where("transacoes.cancelada Is Null Or not transacoes.cancelada") if @exibir_canceladas == "N"
    @total = @transacoes.where("cancelada is null Or cancelada = false").sum("vlr_gasto")
    @total_bonus = @transacoes.where("cancelada is null Or cancelada = false").sum("vlr_gasto * (percentual_bonus_real/100.0)")
  end

end