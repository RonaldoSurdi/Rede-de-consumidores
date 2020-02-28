class CreatePremios < ActiveRecord::Migration
  def change
    create_table :premios do |t|
      t.references :tipo_usuario, index: true
      t.string :descricao
      t.text :descricao_completa

      t.timestamps
    end
  end
end
