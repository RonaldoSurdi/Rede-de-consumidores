class ConfigPagseguro < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller ? controller.current_user : nil }

  validates :email, :token, presence: true
  belongs_to :franquia_user
end