class AddAttachmentImagemToPremios < ActiveRecord::Migration
  def self.up
    change_table :premios do |t|
      t.attachment :imagem
    end
  end

  def self.down
    drop_attached_file :premios, :imagem
  end
end
