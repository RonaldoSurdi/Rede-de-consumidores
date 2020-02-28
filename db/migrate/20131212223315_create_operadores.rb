class CreateOperadores < ActiveRecord::Migration
  def change
    create_table :operadores do |t|
      t.string :nome
      t.references :estabelecimento_user, index: true

      t.timestamps
    end
  end
end
