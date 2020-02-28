class AddIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :nome
    add_index :users, :numero_cartao, unique: true
  end
end
