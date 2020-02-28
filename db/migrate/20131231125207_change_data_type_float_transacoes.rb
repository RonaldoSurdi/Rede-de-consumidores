class ChangeDataTypeFloatTransacoes < ActiveRecord::Migration
 def self.up
    change_table :transacoes do |t|
      t.change :vlr_gasto, :decimal, precision: 15, scale: 6
      t.change :valor_franquia, :decimal, precision: 15, scale: 6
      t.change :valor_padrinho, :decimal, precision: 15, scale: 6
    end
  end

  def self.down
    change_table :transacoes do |t|
      t.change :vlr_gasto, :float
      t.change :valor_franquia, :float
      t.change :valor_padrinho, :float
    end
  end  
end
