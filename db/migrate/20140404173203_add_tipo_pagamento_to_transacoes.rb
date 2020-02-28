class AddTipoPagamentoToTransacoes < ActiveRecord::Migration
  def change
    add_column :transacoes, :tipo_pagamento, :string
  end
end
