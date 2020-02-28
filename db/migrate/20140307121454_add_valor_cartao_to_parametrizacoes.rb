class AddValorCartaoToParametrizacoes < ActiveRecord::Migration
  def change
    add_column :parametrizacoes, :valor_cartao, :float
  end
end
