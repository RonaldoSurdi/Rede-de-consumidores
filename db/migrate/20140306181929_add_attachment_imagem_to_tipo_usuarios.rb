class AddAttachmentImagemToTipoUsuarios < ActiveRecord::Migration
  def self.up
    change_table :tipo_usuarios do |t|
      t.attachment :imagem
    end
  end

  def self.down
    drop_attached_file :tipo_usuarios, :imagem
  end
end
