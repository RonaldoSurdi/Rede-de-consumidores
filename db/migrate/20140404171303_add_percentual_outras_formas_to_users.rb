class AddPercentualOutrasFormasToUsers < ActiveRecord::Migration
  def change
    add_column :users, :percentual_bonus_outras_formas, :float
  end
end
