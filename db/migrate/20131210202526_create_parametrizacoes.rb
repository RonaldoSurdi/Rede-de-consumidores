class CreateParametrizacoes < ActiveRecord::Migration
  def change
    create_table :parametrizacoes do |t|
      t.float :vlr_anuidade_cliente

      t.timestamps
    end
  end
end
