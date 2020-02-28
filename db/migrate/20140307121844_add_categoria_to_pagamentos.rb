class AddCategoriaToPagamentos < ActiveRecord::Migration
  def change
    add_column :pagamentos, :categoria, :string
  end
end
