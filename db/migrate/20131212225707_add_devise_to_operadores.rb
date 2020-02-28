class AddDeviseToOperadores < ActiveRecord::Migration
  def self.up
    change_table(:operadores) do |t|
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""
    end

    add_index :operadores, :email, :unique => true
  end

  def self.down
  end
end
