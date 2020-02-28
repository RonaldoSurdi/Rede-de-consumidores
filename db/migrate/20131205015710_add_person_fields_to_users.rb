class AddPersonFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :juridica_fisica, :string
    add_column :users, :cpf_cnpj, :string
    add_column :users, :nome, :string
    add_column :users, :logradouro, :string
    add_column :users, :bairro, :string
    add_column :users, :complemento, :string
    add_column :users, :numero, :string
    add_column :users, :telefone, :string
    add_column :users, :celular, :string

    add_index :users, :cpf_cnpj, unique: true
  end
end
