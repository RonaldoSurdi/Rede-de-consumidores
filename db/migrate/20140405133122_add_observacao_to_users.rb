class AddObservacaoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :observacao, :string
  end
end
