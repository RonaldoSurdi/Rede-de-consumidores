class AddFkToAllTables < ActiveRecord::Migration
  def change
    add_foreign_key(:banners, :users)

    add_foreign_key(:cities_users, :users)
    add_foreign_key(:cities_users, :cities)

    add_foreign_key(:config_boletos, :users)
    add_foreign_key(:config_pagseguros, :users, column: "franquia_user_id")
    
    add_foreign_key(:movimentos, :users)
    add_foreign_key(:movimentos, :transacoes)

    add_foreign_key(:operadores, :users, column: "estabelecimento_user_id")

    add_foreign_key(:pagamentos, :users, column: "origem_id")
    add_foreign_key(:pagamentos, :users, column: "destino_id")
    add_foreign_key(:pagamentos, :planos_adesoes)

    add_foreign_key(:premios, :tipo_usuarios)

    add_foreign_key(:resgates, :users, column: "cliente_user_id")
    add_foreign_key(:resgates, :premios)

    add_foreign_key(:transacoes, :users, column: "cliente_user_id")
    add_foreign_key(:transacoes, :operadores)

    add_foreign_key(:users, :planos_adesoes, column: "plano_adesao_id")
    add_foreign_key(:users, :users, column: "padrinho_id")
  end
end
