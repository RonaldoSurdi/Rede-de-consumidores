class RemoveVlrAnuidadeClienteFromParametrizacoes < ActiveRecord::Migration
  def change
    remove_column :parametrizacoes, :vlr_anuidade_cliente
  end
end
