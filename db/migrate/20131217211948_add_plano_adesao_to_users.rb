class AddPlanoAdesaoToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :plano_adesao, index: true
    add_column :users, :empresa, :string
  end
end
