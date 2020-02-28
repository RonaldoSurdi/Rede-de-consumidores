class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.date :data_inicial
      t.date :data_final
      t.string :url
      t.string :descricao
    end
  end
end
