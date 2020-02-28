class AddCartaoEmitidoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cartao_emitido, :boolean, default: false
  end
end
