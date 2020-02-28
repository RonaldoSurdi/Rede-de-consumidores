class AddCidadeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cidade, :string
  end
end
