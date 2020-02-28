class FechamentosTest < ActiveSupport::TestCase
  def test_do_caso_1
    Movimento.delete_all
    Movimento.new(data: "01-01-2010".to_date, vlr: 100.0, descricao: "Anuidade", user: users(:origem)).save! #Anuidade

    Transacao.por_periodo("01-01-2010".to_date, "31-01-2010".to_date).order(:created_at).to_a.each do |transacao|
      Movimento.gerar_movimento_do_cliente(transacao).save!
    end

    assert_equal 6.65, Saldo.para(users(:cliente)).saldo.to_f, "Saldo do Cliente 1"
    assert_equal 7.00, Saldo.para(users(:cliente2)).saldo.to_f, "Saldo do Cliente 2"

    Fechamentos.new.do("01-01-2010".to_time)

    assert Transacao.select("sum(valor_franquia) total").first.total.to_f > 0, "Valor da Franquia deve ser diferente de zero"
    assert Transacao.select("sum(valor_padrinho) total").first.total.to_f > 0, "Valor Padrinho deve ser diferente de zero"

    assert_equal 7.46, Saldo.para(users(:cliente)).saldo.to_f, "Saldo final do Cliente 1"
    assert_equal 7.00, Saldo.para(users(:cliente2)).saldo.to_f, "Saldo final do Cliente 2"

    assert_equal -4.20, Saldo.para(users(:estabelecimento)).saldo.to_f, "Saldo final do Estabelecimento 1"
    assert_equal -21.55, Saldo.para(users(:estabelecimento2)).saldo.to_f, "Saldo final do Estabelecimento 2"

    assert_equal 100.15, Saldo.para(users(:origem)).saldo.to_f, "Saldo final da Franquia"
    assert_equal 11.12, Saldo.para(AdminUser.master).saldo.to_f, "Saldo final da Administração"
  end

  def test_do_caso_2
    Movimento.delete_all
    Transacao.por_periodo("01-01-2011".to_date, "31-01-2011".to_date).order(:created_at).to_a.each do |transacao|
      Movimento.gerar_movimento_do_cliente(transacao).save!
    end

    Fechamentos.new.do("  01-01-2011".to_date)

    assert Transacao.select("sum(valor_franquia) total").first.total.to_f > 0, "Valor da Franquia deve ser diferente de zero"
    assert Transacao.select("sum(valor_padrinho) total").first.total.to_f == 0, "Valor Padrinho deve igual a zero"

    assert_equal 53.25, Saldo.para(users(:cliente)).saldo.to_f, "Saldo do Cliente 1"

    assert_equal -10.0, Saldo.para(users(:estabelecimento2)).saldo.to_f, "Saldo do Estabelecimento 2"
    assert_equal -71.0, Saldo.para(users(:estabelecimento3)).saldo.to_f, "Saldo final do Estabelecimento 3"
    assert_equal 9.53, Saldo.para(users(:estabelecimento4)).saldo.to_f, "Saldo final do Estabelecimento 4"

    assert_equal 9.0, Saldo.para(users(:origem)).saldo.to_f, "Saldo final da Franquia Origem"
    assert_equal 7.39, Saldo.para(users(:franquia_getulio)).saldo.to_f, "Saldo final da Franquia"

    assert_equal 1.82, Saldo.para(AdminUser.master).saldo.to_f, "Saldo final da Administração"
  end

  def test_do_caso_3
    Movimento.delete_all

    ActiveRecord::Base.transaction do
      Transacao.por_periodo("01-01-2012".to_date, "31-01-2012".to_date).joins(:cliente_user).includes(:cliente_user).order(:created_at).to_a.each do |transacao|
        Movimento.gerar_movimento_do_cliente(transacao).save!
      end
    end

    assert_equal 445.45, Saldo.para(users(:cliente)).saldo.to_f, "Saldo do Cliente 1"

    Fechamentos.new.do("01-01-2012".to_date)

    assert Transacao.select("sum(valor_franquia) total").first.total.to_f > 0, "Valor da Franquia deve ser diferente de zero"
    assert Transacao.select("sum(valor_padrinho) total").first.total.to_f == 0, "Valor Padrinho deve igual a zero"

    assert_equal -10.0, Saldo.para(users(:estabelecimento2)).saldo.to_f, "Saldo do Estabelecimento 2"
    assert_equal -496.0, Saldo.para(users(:estabelecimento)).saldo.to_f, "Saldo final do Estabelecimento"

    assert_equal 54.49, Saldo.para(users(:origem)).saldo.to_f, "Saldo Final da Franquia"

    assert_equal 6.05, Saldo.para(AdminUser.master).saldo.to_f, "Saldo Final da Administração"
  end

end