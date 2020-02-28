class AddFieldsToParametrizacoes < ActiveRecord::Migration
  def change
    add_column :parametrizacoes, :vlr_consumo_medio_para_resgate_premios, :float
    add_column :parametrizacoes, :prazo_entrega_premio, :int
  end
end
