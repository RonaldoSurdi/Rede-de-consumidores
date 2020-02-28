class AddPadrinhoToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :padrinho, index: true
  end
end
