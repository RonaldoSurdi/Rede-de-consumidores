class AddIndexToMovimentos < ActiveRecord::Migration
  def change
    add_index :movimentos, :data
  end
end
