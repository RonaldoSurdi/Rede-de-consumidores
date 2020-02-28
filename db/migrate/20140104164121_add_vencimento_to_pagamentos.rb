class AddVencimentoToPagamentos < ActiveRecord::Migration
  def change
    add_column :pagamentos, :data_vencimento, :date
  end
end
