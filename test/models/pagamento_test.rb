require 'test_helper'

class PagamentoTest < ActiveSupport::TestCase
  test "Anuidade sem Padrinho" do
    Movimento.delete_all
    Pagamento.delete_all

    cliente = users(:cliente)
    pagamento = Pagamento.gerar_anuidade! cliente, PlanosAdesao.basico.id, :boleto
    assert_equal PlanosAdesao.basico.vlr_anuidade.to_f, pagamento.valor.to_f

    pagamento = Pagamento.gerar_anuidade! cliente, PlanosAdesao.advanced.id, :boleto
    assert_equal PlanosAdesao.advanced.vlr_anuidade.to_f, pagamento.valor.to_f
    assert_equal :boleto, pagamento.tipo_pagamento
    assert_equal PlanosAdesao.advanced.id, pagamento.planos_adesao_id

    pagamento.confirmar_anuidade!
    assert_equal PlanosAdesao.advanced.vlr_anuidade.to_f, Saldo.para(cliente.franquia).saldo.to_f
  end

  test "Anuidade Plano Básico com Padrinho" do
    Movimento.delete_all
    Pagamento.delete_all

    cliente = users(:cliente2)
    pagamento = Pagamento.gerar_anuidade! cliente, PlanosAdesao.advanced, :boleto
    pagamento.confirmar_anuidade!
    assert_equal PlanosAdesao.basico.vlr_indicado, Saldo.para(cliente.padrinho).saldo.to_f
    assert_equal PlanosAdesao.advanced.vlr_anuidade - PlanosAdesao.basico.vlr_indicado, Saldo.para(cliente.franquia).saldo.to_f

    assert_equal 1, cliente.padrinho.quantidade_indicacoes
  end

  test "Anuidade Plano Advanced com Padrinho" do
    Movimento.delete_all
    Pagamento.delete_all

    padrinho = users(:cliente)
    padrinho.update! quantidade_indicacoes: 0
    pagamento = Pagamento.gerar_anuidade! padrinho, PlanosAdesao.advanced, :boleto
    pagamento.confirmar_anuidade!

    cliente = users(:cliente2)
    pagamento = Pagamento.gerar_anuidade! cliente, PlanosAdesao.advanced, :boleto
    pagamento.confirmar_anuidade!
    assert_equal PlanosAdesao.advanced.vlr_indicado, Saldo.para(padrinho).saldo.to_f
    assert_equal (PlanosAdesao.advanced.vlr_anuidade * 2) - PlanosAdesao.advanced.vlr_indicado, Saldo.para(cliente.franquia).saldo.to_f # *2 para somar a anuidade paga pelo padrinho
    
    assert_equal 0, cliente.quantidade_indicacoes
    assert_equal 2, cliente.padrinho.quantidade_indicacoes
  end  
end