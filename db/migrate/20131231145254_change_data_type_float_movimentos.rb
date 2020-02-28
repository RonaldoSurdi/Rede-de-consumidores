class ChangeDataTypeFloatMovimentos < ActiveRecord::Migration
 def self.up
    change_table :movimentos do |t|
      t.change :vlr, :decimal, precision: 15, scale: 6
    end
  end

  def self.down
    change_table :movimentos do |t|
      t.change :vlr, :float
    end
  end  
end
