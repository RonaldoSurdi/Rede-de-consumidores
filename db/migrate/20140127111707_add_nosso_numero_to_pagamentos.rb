class AddNossoNumeroToPagamentos < ActiveRecord::Migration
  def change
    add_column :pagamentos, :nosso_numero, :string
  end
end
