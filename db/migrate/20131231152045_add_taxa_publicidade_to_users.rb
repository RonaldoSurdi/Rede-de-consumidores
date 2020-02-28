class AddTaxaPublicidadeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :taxa_publicidade, :float
  end
end
