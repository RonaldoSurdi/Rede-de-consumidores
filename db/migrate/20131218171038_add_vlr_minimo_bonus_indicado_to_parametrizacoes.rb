class AddVlrMinimoBonusIndicadoToParametrizacoes < ActiveRecord::Migration
  def change
    add_column :parametrizacoes, :vlr_minimo_bonus_indicacao, :float
  end
end
