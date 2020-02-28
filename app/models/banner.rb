class Banner < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller ? controller.current_user : nil }

  attr_accessor :data_inicial_str, :data_final_str

  before_save :before_save
  after_initialize :after_initialize

  @@tipos = {
    0 => {descricao: "Banner Principal (960x300)", largura: 960, altura: 300},
    1 => {descricao: "Banner Secundário (960x200)", largura: 960, altura: 200}
  }

  belongs_to :user
  has_attached_file :file, styles: lambda { |attachment| { original: "#{attachment.instance.hash_tipo[:largura]}x#{attachment.instance.hash_tipo[:altura]}>" } }

  validates :descricao, :tipo, presence: true
  validates :file, attachment_presence: true
  validate :validar_data_inicial, :validar_data_final
  validates_attachment :file, 
                         presence: true,
                         content_type: { content_type: ["image/jpg", "image/jpeg", "image/gif", "image/png"] }

  scope :somente_ativos, -> { where("data_inicial Is Null Or data_inicial <= Date(now())").where("data_final Is Null Or data_final >= Date(now())") }


  def self.tipos
    @@tipos
  end

  def hash_tipo
    @@tipos[tipo.to_i]
  end

  def self.ativos(tipo)
    raise "Tipo Inválido" unless @@tipos[tipo.to_i]
    scope = Banner.somente_ativos
              .joins(:user)
              .where(tipo: tipo)
              .order("Case When users.type = 'AdminUser' then 0 else 1 End, rand()")
  end

  def self.ativos_da_cidade(tipo, cidade)
    raise "Tipo Inválido" unless @@tipos[tipo.to_i]
    scope = Banner.somente_ativos
              .select("distinct banners.*")
              .joins(:user)
              .joins("Left Join cities_users on cities_users.user_id = users.id")
              .where(tipo: tipo)
              .where("(users.type = 'FranquiaUser' And cities_users.city_id In (?)) Or users.type = 'AdminUser'", cidade.is_a?(City) ? cidade.id : cidade)
              .order("Case When users.type = 'FranquiaUser' then 0 else 1 End, rand()")
  end

  private

  def validar_data_inicial
    data_inicial_str.to_s.to_date
  rescue
    errors.add(:data_inicial_str, "Data inválida")
  end

  def validar_data_final
    data_final_str.to_s.to_date
  rescue
    errors.add(:data_final_str, "Data inválida")
  end

  def before_save
    self.data_inicial = data_inicial_str.to_date unless data_inicial_str.blank?
    self.data_final = data_final_str.to_date unless data_final_str.blank?
  end

  def after_initialize
    self.data_inicial_str = data_inicial.to_s_br if data_inicial
    self.data_final_str = data_final.to_s_br if data_final
  end
end