class Premio < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller ? controller.current_user : nil }

  belongs_to :tipo_usuario
  has_attached_file :imagem

  validates :descricao, :tipo_usuario, :descricao_completa, presence: true
  validates_attachment :imagem, presence: true, content_type: { content_type: ["image/jpg", "image/jpeg", "image/gif", "image/png"] }

  scope :premios_disponiveis_usuario, ->(user) {
    joins(:tipo_usuario)
    .where("tipo_usuarios.quantidade_indicacoes <= ?", user.quantidade_indicacoes)
    .where("Not Exists (Select 1 from resgates r Left Join premios p On p.id = r.premio_id Where p.tipo_usuario_id = tipo_usuarios.id And r.cliente_user_id = ?)", user.id)
  }
end
