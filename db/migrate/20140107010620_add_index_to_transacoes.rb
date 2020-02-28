class AddIndexToTransacoes < ActiveRecord::Migration
  def change
    add_index :transacoes, :created_at
    add_index :transacoes, :forma_pagamento
    add_index :transacoes, :cancelada
  end
end
