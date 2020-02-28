class CreateTransacoes < ActiveRecord::Migration
  def change
    create_table :transacoes do |t|
      t.string :forma_pagamento
      t.float :vlr_gasto
      t.references :cliente_user, index: true
      t.references :operador, index: true

      t.timestamps
    end
  end
end