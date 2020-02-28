class AddPercentualToTransacoes < ActiveRecord::Migration
  def change
    add_column :transacoes, :percentual_bonus_real, :float
  end
end
