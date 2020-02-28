class AddTransacaoToMovimento < ActiveRecord::Migration
  def change
    add_reference :movimentos, :transacao, index: true
  end
end
