class CreateMovimentos < ActiveRecord::Migration
  def change
    create_table :movimentos do |t|
      t.date :data
      t.float :vlr
      t.references :user, index: true
      t.string :descricao

      t.timestamps
    end
  end
end
