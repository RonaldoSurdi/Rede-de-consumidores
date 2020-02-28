class AddMoreFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :data_nascimento, :date
    add_column :users, :estado_civil, :string
    add_column :users, :sexo, :string
  end
end
