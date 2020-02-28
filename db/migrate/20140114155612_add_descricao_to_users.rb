class AddDescricaoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :descricao, :string
  end
end
