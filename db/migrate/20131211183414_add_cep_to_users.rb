class AddCepToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cep, :string
  end
end
