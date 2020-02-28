class AddValoresToTransacoes < ActiveRecord::Migration
  def change
    add_column :transacoes, :valor_franquia, :float
    add_column :transacoes, :valor_padrinho, :float
  end
end
