class CreatePlanosAdesoes < ActiveRecord::Migration
  def change
    create_table :planos_adesoes do |t|
      t.float :vlr_anuidade
      t.float :vlr_indicado
      t.string :descricao

      t.timestamps
    end
  end
end
