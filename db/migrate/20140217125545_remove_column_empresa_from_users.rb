class RemoveColumnEmpresaFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :empresa, :string
  end
end
