class CreateConfigPagseguros < ActiveRecord::Migration
  def change
    create_table :config_pagseguros do |t|
      t.references :franquia_user, index: true
      t.string :email
      t.string :token

      t.timestamps
    end
  end
end
