class AddNrCartaoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :numero_cartao, :string
  end
end
