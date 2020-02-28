class DropTableAnuidades < ActiveRecord::Migration
  def up
    drop_table :anuidades
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
