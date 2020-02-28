class AddTipoPagamentoToPagamentos < ActiveRecord::Migration
  def change
    add_column :pagamentos, :tipo_pagamento, :string
  end
end
