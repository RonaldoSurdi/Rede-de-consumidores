class Admin::ConfigBoletosController < Admin::AdminController
  before_action :set_config, only: [:index, :show, :edit, :update, :new, :create, :test]

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

  def test
    require "boleto_factory"

    banco = ConfigBoleto.bancos[@config.banco.to_sym]
    boleto = banco[:classe].new
    boleto.local_pagamento = "QUALQUER BANCO ATE O VENCIMENTO"

    boleto.convenio = @config.convenio
    boleto.agencia = @config.agencia
    boleto.conta_corrente = @config.conta_corrente

    boleto.numero_documento = BoletoFactory.numero_documento_formatado @config.banco, 200
    boleto.valor = 1.98

    boleto.cedente = "Cedente"
    boleto.documento_cedente = "69345751300"

    boleto.sacado = current_user.nome.remover_acentos
    boleto.sacado_documento = current_user.cpf_cnpj || "32118545410"

    boleto.dias_vencimento = @config.dias_vencimento
    boleto.data_documento = Date.today

    instrucoes = @config.instrucoes.remover_acentos.gsub("\r", "").split("\n")
    boleto.instrucao1 = instrucoes[0] if instrucoes.length > 0
    boleto.instrucao2 = instrucoes[1] if instrucoes.length > 1
    boleto.instrucao3 = instrucoes[2] if instrucoes.length > 2
    boleto.instrucao4 = instrucoes[3] if instrucoes.length > 3
    boleto.instrucao5 = instrucoes[4] if instrucoes.length > 4
    boleto.instrucao6 = instrucoes[5] if instrucoes.length > 5

    boleto.sacado_endereco = "Endereço".remover_acentos

    if @config.banco.to_sym == :sicredi
      boleto.posto = @config.posto
      boleto.byte_idt = @config.byte_geracao
    end

    headers["Content-Type"] = "application/pdf; charset=ISO8859-1"
    send_data boleto.to(:pdf), filename: "Boleto-#{boleto.numero_documento}.pdf"
  rescue Exception
    redirect_to config_boletos_path, alert: "Falha ao gerar boleto - #{$!}"
  end

  private

  def set_config
    user = current_user.is_a?(AdminUser) ? AdminUser.master : current_user
    @config = ConfigBoleto.where(user: user).first || ConfigBoleto.new(user: user)
  end

  def config_params
    params.require(:config_boleto).permit(:banco, :convenio, :agencia, :conta_corrente, :dias_vencimento, :instrucoes, :posto, :byte_geracao).merge(user: current_user)
  end

  def create_or_update
    if @config.update(config_params)
      redirect_to @config, notice: 'Configurações atualizadas com Sucesso.'
    else
      render action: 'edit'
    end
  end
end