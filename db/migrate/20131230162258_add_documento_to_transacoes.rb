class AddDocumentoToTransacoes < ActiveRecord::Migration
  def change
    add_column :transacoes, :documento, :string
  end
end
