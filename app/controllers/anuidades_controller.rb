class AnuidadesController < ApplicationController
  require "pagseguro_factory"
  layout "painel"

  before_filter :authenticate_cliente_user!
  before_filter :load, only: [:create, :new]
  
  def index
    @pagamento_em_aberto = Pagamento.where(origem: current_cliente_user, status: :aguardando, categoria: :anuidade).order(updated_at: :desc).first
    @ultimo_pagamento = Pagamento.where(origem: current_cliente_user, status: :pago, categoria: :anuidade).order(updated_at: :desc).first
    @nao_precisa_pagar = current_cliente_user.anuidade_paga?.is_a?(TrueClass)
  end

  def create
    ActiveRecord::Base.transaction do
      pagamento = Pagamento.gerar_anuidade!(current_cliente_user, params[:plano_adesao_id], params[:tipo])
      if pagamento.tipo_pagamento.to_sym == :boleto
        redirect_to public_anuidade_index_url, notice: "Seu boleto foi enviado por email"
      else
        pagseguro = PagSeguroFactory.create!(pagamento, public_anuidade_index_url)
        pagamento.update! url_pagseguro: pagseguro.url

        redirect_to pagseguro.url
      end
    end
  rescue
    redirect_to public_anuidade_index_url, alert: "Erro ao registrar pagamento - #{$!}"
  end

  def show
    pagamento = Pagamento.find(params[:id])
    if pagamento.tipo_pagamento.to_sym == :boleto
      boleto = BoletoFactory.new(pagamento).gerar
      headers["Content-Type"] = "application/pdf; charset=ISO8859-1"
      send_data boleto.to(:pdf), filename: "Boleto-#{boleto.numero_documento}.pdf", disposition: :inline
    else
      redirect_to pagamento.url_pagseguro
    end
  end

  private

  def load
    @planos = PlanosAdesao.order(:descricao).to_a
  end
end
