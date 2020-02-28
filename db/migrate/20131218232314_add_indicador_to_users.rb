class AddIndicadorToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :cliente_user_indicador, index: true
  end
end
