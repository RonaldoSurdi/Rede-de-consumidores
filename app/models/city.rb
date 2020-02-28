class City < ActiveRecord::Base
  extend FriendlyId
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller ? controller.current_user : nil }
  
  before_destroy :validate_destroy

  friendly_id :full_name, use: [:slugged, :history]

  validates_presence_of :description, :uf
  scope :somente_cidades_com_franquia, -> { where("cities.id In (Select Distinct cu.city_id From cities_users cu Left Join users u On u.id = cu.user_id And u.type = 'FranquiaUser')") }

  def full_name
    "#{description} - #{uf}"
  end

  private

  def validate_destroy
    raise "Existem Usuários cadastrados nesta cidade" if User.joins(:cities).where(cities_users: {city_id: self.id}).exists?
  end
end
