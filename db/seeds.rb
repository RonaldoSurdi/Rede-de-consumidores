AdminUser.create(email: "admin@consumercard.net", password: "123456", nome: "Rede ConsumerCard", cpf_cnpj: "19.515.763/0001-01") unless AdminUser.first

Parametrizacao.create(percentual_cliente: 90.0, percentual_franquia: 2.0, percentual_indicado: 8.0, vlr_minimo_bonus_indicacao: 10.0, percentual_administracao: 10.0) unless Parametrizacao.first

PlanosAdesao.create(vlr_indicado: 30.0, vlr_anuidade: 100.0, descricao: "ConsumerCard", quantidade_indicacoes: 1)
PlanosAdesao.create(vlr_indicado: 40.0, vlr_anuidade: 130.0, descricao: "ConsumerCard Advanced", quantidade_indicacoes: 2)