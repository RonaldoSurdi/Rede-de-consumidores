class AddImportadoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :importado, :boolean, default: false, null: false
  end
end
