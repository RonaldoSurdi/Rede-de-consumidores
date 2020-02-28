class AddPlanosAdesaoToPagamentos < ActiveRecord::Migration
  def change
    add_reference :pagamentos, :planos_adesao, index: true
  end
end
