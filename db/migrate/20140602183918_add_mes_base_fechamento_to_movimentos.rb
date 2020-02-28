class AddMesBaseFechamentoToMovimentos < ActiveRecord::Migration
  def change
    add_column :movimentos, :fechamento_mes_base, :integer
  end
end
