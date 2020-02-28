class AddPercentualBonusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :percentual_bonus_real, :float
  end
end
