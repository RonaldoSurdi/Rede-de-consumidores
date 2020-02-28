class RemoveDtHraEmissaoFromPagamentos < ActiveRecord::Migration
  def change
    remove_column :pagamentos, :dt_hra_emissao, :timestamp
    remove_column :pagamentos, :tipo, :string
  end
end
