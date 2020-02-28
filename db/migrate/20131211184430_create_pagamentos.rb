class CreatePagamentos < ActiveRecord::Migration
  def change
    create_table :pagamentos do |t|
      t.string :tipo
      t.float :valor
      t.timestamp :dt_hra_emissao
      t.string :status
      t.references :origem, index: true
      t.references :destino, index: true

      t.timestamps
    end
  end
end
