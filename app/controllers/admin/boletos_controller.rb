require "boleto_factory"

class Admin::BoletosController < Admin::AdminController
  before_filter :authenticate_user!

  def show
    pagamento = Pagamento.find(params[:id])
    boleto = BoletoFactory.new(pagamento).gerar
    headers["Content-Type"] = "application/pdf; charset=ISO8859-1"
    send_data boleto.to(:pdf), filename: "Boleto-#{boleto.numero_documento}.pdf"
  end

  def enviar_email
    pagamento = Pagamento.find(params[:id])

    if pagamento.categoria.to_sym == :cartao
      boleto = BoletoFactory.new(pagamento).gerar
      CartaoMailer.send_boleto_cliente(pagamento, boleto).deliver
    else
      EmailBoletoWorker.perform_async(params[:id])
    end

    render nothing: true
  rescue
    render nothing: true, status: 500
  end
end
