class AddAttachmentLogoToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :logo
    end
  end

  def self.down
    drop_attached_file :users, :logo
  end
end
