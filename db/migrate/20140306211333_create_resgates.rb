class CreateResgates < ActiveRecord::Migration
  def change
    create_table :resgates do |t|
      t.references :cliente_user, index: true
      t.references :premio, index: true
      t.boolean :enviado

      t.timestamps
    end
  end
end
