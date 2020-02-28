class AddAnoBaseFechamentoToMovimentos < ActiveRecord::Migration
  def change
    add_column :movimentos, :fechamento_ano_base, :integer
  end
end
