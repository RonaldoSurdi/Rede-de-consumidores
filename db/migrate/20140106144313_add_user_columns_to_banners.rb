class AddUserColumnsToBanners < ActiveRecord::Migration
  def change
    add_reference :banners, :user, index: true
  end
end
