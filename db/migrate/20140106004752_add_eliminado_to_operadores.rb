class AddEliminadoToOperadores < ActiveRecord::Migration
  def change
    add_column :operadores, :eliminado, :boolean
  end
end
