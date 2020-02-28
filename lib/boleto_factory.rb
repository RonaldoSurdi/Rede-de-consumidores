class BoletoFactory
  def initialize(pagamento)
    @pagamento = pagamento
  end

  def gerar
    banco = ConfigBoleto.bancos[@pagamento.destino.config_boleto.banco.to_sym]
    boleto = banco[:classe].new

    boleto.local_pagamento = "QUALQUER BANCO ATE O VENCIMENTO"

    boleto.convenio = @pagamento.destino.config_boleto.convenio
    boleto.agencia = @pagamento.destino.config_boleto.agencia
    boleto.conta_corrente = @pagamento.destino.config_boleto.conta_corrente

    boleto.numero_documento = BoletoFactory.numero_documento_formatado(@pagamento.destino.config_boleto.banco, @pagamento.id)
    boleto.valor = @pagamento.valor

    boleto.cedente = @pagamento.destino.nome.remover_acentos
    boleto.documento_cedente = "19515763000101"
    #boleto.documento_cedente = @pagamento.destino.cpf_cnpj

    boleto.sacado = @pagamento.origem.nome.remover_acentos
    boleto.sacado_documento = @pagamento.origem.cpf_cnpj

    boleto.dias_vencimento = @pagamento.destino.config_boleto.dias_vencimento
    boleto.data_documento = @pagamento.created_at.to_date

    instrucoes = @pagamento.destino.config_boleto.instrucoes.remover_acentos.gsub("\r", "").split("\n")
    boleto.instrucao1 = instrucoes[0] if instrucoes.length > 0
    boleto.instrucao2 = instrucoes[1] if instrucoes.length > 1
    boleto.instrucao3 = instrucoes[2] if instrucoes.length > 2
    boleto.instrucao4 = instrucoes[3] if instrucoes.length > 3
    boleto.instrucao5 = instrucoes[4] if instrucoes.length > 4
    boleto.instrucao6 = instrucoes[5] if instrucoes.length > 5

    boleto.sacado_endereco = "#{@pagamento.origem.logradouro} - #{@pagamento.origem.numero} - #{@pagamento.origem.bairro} - #{@pagamento.origem.cep}".remover_acentos

    if @pagamento.destino.config_boleto.banco.to_sym == :sicredi
      boleto.posto = @pagamento.destino.config_boleto.posto
      boleto.byte_idt = @pagamento.destino.config_boleto.byte_geracao
    end

    Pagamento.find(@pagamento.id).update(nosso_numero: boleto.numero_documento) unless @pagamento.nosso_numero
    boleto
  end

  def self.numero_documento_formatado(banco, numero)
    if banco.to_sym == :caixa
        "%015d" % numero.to_i
    else
        numero.to_s
    end
  end
end