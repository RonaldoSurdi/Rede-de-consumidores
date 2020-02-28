class CreateAnuidades < ActiveRecord::Migration
  def change
    create_table :anuidades do |t|
      t.string :status
      t.text :descricao
      t.timestamp :alteracao_status
      t.references :cliente_user, index: true

      t.timestamps
    end
  end
end
