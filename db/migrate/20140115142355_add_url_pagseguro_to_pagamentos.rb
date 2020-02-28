class AddUrlPagseguroToPagamentos < ActiveRecord::Migration
  def change
    add_column :pagamentos, :url_pagseguro, :string
  end
end
