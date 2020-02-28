class AddFieldsSicrediToConfigBoletos < ActiveRecord::Migration
  def change
    add_column :config_boletos, :posto, :string
    add_column :config_boletos, :byte_geracao, :string
  end
end
