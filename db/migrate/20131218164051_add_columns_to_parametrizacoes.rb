class AddColumnsToParametrizacoes < ActiveRecord::Migration
  def change
    add_column :parametrizacoes, :percentual_cliente, :float
    add_column :parametrizacoes, :percentual_franquia, :float
    add_column :parametrizacoes, :percentual_indicado, :float
  end
end
