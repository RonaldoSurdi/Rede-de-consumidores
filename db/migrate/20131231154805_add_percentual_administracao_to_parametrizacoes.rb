class AddPercentualAdministracaoToParametrizacoes < ActiveRecord::Migration
  def change
    add_column :parametrizacoes, :percentual_administracao, :float
  end
end
