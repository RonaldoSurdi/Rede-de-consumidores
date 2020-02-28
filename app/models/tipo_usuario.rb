class TipoUsuario < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller ? controller.current_user : nil }

  before_destroy :validate_destroy

  validates :descricao, presence: true
  has_attached_file :imagem
  validates_attachment :imagem, content_type: { content_type: ["image/jpg", "image/jpeg", "image/gif", "image/png"] }
  has_many :premios

  private

  def validate_destroy
    raise "Existem Prêmios cadastrados para este tipo de usuário" if Premio.where(tipo_usuario_id: self.id).exists?
  end
end