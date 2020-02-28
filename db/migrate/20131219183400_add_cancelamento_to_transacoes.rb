class AddCancelamentoToTransacoes < ActiveRecord::Migration
  def change
    add_column :transacoes, :cancelada, :boolean
    add_column :transacoes, :motivo, :string
  end
end
