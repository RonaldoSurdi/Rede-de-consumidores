class AddColumnQuantidadeIndicacoesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :quantidade_indicacoes, :integer
  end
end
