class AddColumnsToBanners < ActiveRecord::Migration
  def change
    add_column :banners, :tipo, :string
  end
end
