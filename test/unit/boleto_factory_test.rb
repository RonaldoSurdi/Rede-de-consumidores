require "test_helper"
require "boleto_factory"

class BoletoFactoryTest < ActiveSupport::TestCase

  def test_gerar
    pagamento = pagamentos(:pagamento_1)
    boleto = BoletoFactory.new(pagamento).gerar

    assert_not_nil boleto

    assert Brcobranca::Boleto::Itau, boleto.class

    assert_equal "00123", boleto.convenio
    assert_equal "0456", boleto.agencia
    assert_equal "00789", boleto.conta_corrente

    assert_equal pagamento.id.to_s, boleto.numero_documento.to_s
    assert_equal pagamento.valor, boleto.valor

    assert_equal pagamento.origem.nome, boleto.cedente
    assert_equal pagamento.origem.cpf_cnpj, boleto.documento_cedente

    assert_equal pagamento.destino.nome, boleto.sacado
    assert_equal pagamento.destino.cpf_cnpj, boleto.sacado_documento

    assert_equal pagamento.origem.config_boleto.dias_vencimento, boleto.dias_vencimento
    assert_equal pagamento.created_at.to_date, boleto.data_documento

    
    assert_equal "Linha 1", boleto.instrucao1
    assert_equal "Linha 2", boleto.instrucao2
    assert_equal "Linha 3 AA", boleto.instrucao3
    assert_nil boleto.instrucao4
  end

end