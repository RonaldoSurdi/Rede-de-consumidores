class AddFlagsToPagamentos < ActiveRecord::Migration
  def change
    add_column :pagamentos, :recebido, :boolean
  end
end
