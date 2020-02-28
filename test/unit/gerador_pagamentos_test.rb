class GeradorPagamentosTest < ActiveSupport::TestCase
  def test_gerar_caso_1
    Movimento.delete_all
    Pagamento.delete_all
    
    Transacao.por_periodo("01-01-2010".to_date, "31-01-2010".to_date).order(:created_at).to_a.each do |transacao|
      Movimento.gerar_movimento_do_cliente(transacao).save!
    end

    Fechamentos.new.do("01-01-2010".to_date)
    GeradorPagamentos.new("01-02-2010".to_date).gerar!

    #Pagamento para Administração
    pagamento_para_adm = Pagamento.where(origem: users(:estabelecimento).franquia, destino: AdminUser.master).first    
    assert pagamento_para_adm, "Pagamento para Adm não pode ser nulo"
    assert_equal 1.13, pagamento_para_adm.valor.to_f, "Valor do Pagamento para Adm"

    #Pagamento Estabelecimento 1 para Franquia
    pagamento_para_franquia = Pagamento.where(origem: users(:estabelecimento), destino: users(:estabelecimento).franquia).first
    assert pagamento_para_franquia, "Pagamento para Franquia não pode ser nulo"
    assert_equal 4.20, pagamento_para_franquia.valor.to_f, "Pagamento para Franquia"

    #Pagamento Estabelecimento 2 para Franquia
    pagamento_para_franquia = Pagamento.where(origem: users(:estabelecimento2), destino: users(:estabelecimento2).franquia).first
    assert pagamento_para_franquia, "Pagamento para Franquia não pode ser nulo"
    assert_equal 21.55, pagamento_para_franquia.valor.to_f, "Pagamento para Franquia"
  end

  def test_gerar_caso_2
    Movimento.delete_all
    Pagamento.delete_all
    
    Transacao.por_periodo("01-01-2011".to_date, "31-01-2011".to_date).order(:created_at).to_a.each do |transacao|
      Movimento.gerar_movimento_do_cliente(transacao).save!
    end

    Fechamentos.new.do("01-01-2011".to_date)
    GeradorPagamentos.new("01-02-2011".to_date).gerar!

    #Pagamento Estabelecimento 2 para Franquia
    pagamento_para_franquia = Pagamento.where(origem: users(:estabelecimento2), destino: users(:estabelecimento2).franquia).first
    assert pagamento_para_franquia, "Pagamento para Franquia não pode ser nulo"
    assert_equal 10.00, pagamento_para_franquia.valor.to_f, "Pagamento para Franquia"

    #Pagamento Estabelecimento 3 para Franquia
    pagamento_para_franquia = Pagamento.where(origem: users(:estabelecimento3), destino: users(:estabelecimento3).franquia).first
    assert pagamento_para_franquia, "Pagamento para Franquia não pode ser nulo"
    assert_equal 4425.84, pagamento_para_franquia.valor.to_f, "Pagamento para Franquia"

    #Pagamento Franquia para Estabelecimento 4
    pagamento_para_franquia = Pagamento.where(origem: users(:estabelecimento4).franquia, destino: users(:estabelecimento4)).first
    assert pagamento_para_franquia, "Pagamento para Franquia não pode ser nulo"
    assert_equal 9.53, pagamento_para_franquia.valor.to_f, "Pagamento para Franquia"

    #Pagamento Franquia para Estabelecimento 4
    pagamento_para_franquia = Pagamento.where(origem: users(:estabelecimento4).franquia, destino: users(:estabelecimento4)).first
    assert pagamento_para_franquia, "Pagamento para Franquia não pode ser nulo"
    assert_equal 9.53, pagamento_para_franquia.valor.to_f, "Pagamento para Franquia"

    #Pagamento Franquia Origem para Adm
    pagamento_para_admn = Pagamento.where(origem: users(:origem), destino: AdminUser.master).first
    assert pagamento_para_admn, "Pagamento para Admin não pode ser nulo"
    assert_equal 1.00, pagamento_para_admn.valor.to_f, "Pagamento para Admin"

    #Pagamento Franquia Getulio para Adm
    pagamento_para_admn = Pagamento.where(origem: users(:franquia_getulio), destino: AdminUser.master).first
    assert pagamento_para_admn, "Pagamento para Admin não pode ser nulo"
    assert_equal 44.37, pagamento_para_admn.valor.to_f, "Pagamento para Admin"
  end
end