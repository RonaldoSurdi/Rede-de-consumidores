class CreateTipoUsuarios < ActiveRecord::Migration
  def change
    create_table :tipo_usuarios do |t|
      t.string :descricao
      t.integer :quantidade_indicacoes

      t.timestamps
    end
  end
end
