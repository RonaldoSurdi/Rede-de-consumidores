class AddRazaoSocialToUsers < ActiveRecord::Migration
  def change
    add_column :users, :razao_social, :string
  end
end
