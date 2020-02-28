class CartoesController < ApplicationController
  before_filter :authenticate_cliente_user!
  layout "painel"

  def index
    @solicitacao = Pagamento.where(origem: current_cliente_user, status: :aguardando, categoria: :cartao).first
  end

  def create
    pagamento = nil
    boleto = nil

    ActiveRecord::Base.transaction do
      pagamento = Pagamento.where(origem: current_cliente_user, categoria: :cartao)
      pagamento.first.destroy! if pagamento.exists?
      pagamento = Pagamento.create!({
        valor: Parametrizacao.first.valor_cartao,
        origem: current_cliente_user,
        destino: AdminUser.master,
        categoria: :cartao,
        status: :aguardando
      })

      boleto = BoletoFactory.new(pagamento).gerar
      pagamento.update! nosso_numero: boleto.numero_documento
    end

    CartaoMailer.send_boleto_cliente(pagamento, boleto).deliver
    CartaoMailer.send_informacoes_to_admin(pagamento).deliver

    redirect_to painel_cliente_index_url, notice: "Foi enviado o boleto para o seu e-mail"
  rescue
    redirect_to painel_cliente_index_url, alert: "Falha ao solicitar segunda via do cartão, tente novamente"
  end
end