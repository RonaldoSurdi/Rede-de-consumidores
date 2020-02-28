class AddColumnQuantidadeIndicacoesFromPlanosAdesao < ActiveRecord::Migration
  def change
    add_column :planos_adesoes, :quantidade_indicacoes, :integer
  end
end
