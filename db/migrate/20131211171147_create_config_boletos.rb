class CreateConfigBoletos < ActiveRecord::Migration
  def change
    create_table :config_boletos do |t|
      t.string :banco
      t.string :convenio
      t.string :agencia
      t.string :conta_corrente
      t.integer :dias_vencimento
      t.text :instrucoes
      t.references :user, index: true

      t.timestamps
    end
  end
end
