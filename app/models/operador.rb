class Operador < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller ? controller.current_user : nil }
  
  devise :database_authenticatable

  belongs_to :estabelecimento_user
  has_many :transacoes

  validates_uniqueness_of :email
  validates_presence_of :nome, :email, :estabelecimento_user

  default_scope  { where("eliminado Is Null Or eliminado = false")}  

  def destroy
    self.eliminado = true
    save
  end

  def destroy!
    self.eliminado = true
    save!
  end
end