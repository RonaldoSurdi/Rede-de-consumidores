class AddAttachmentFileToBanners < ActiveRecord::Migration
  def self.up
    change_table :banners do |t|
      t.attachment :file
    end
  end

  def self.down
    drop_attached_file :banners, :file
  end
end
