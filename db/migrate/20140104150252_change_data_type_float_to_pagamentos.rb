class ChangeDataTypeFloatToPagamentos < ActiveRecord::Migration
 def self.up
    change_table :pagamentos do |t|
      t.change :valor, :decimal, precision: 15, scale: 6
    end
  end

  def self.down
    change_table :pagamentos do |t|
      t.change :valor, :float
    end
  end  
end
