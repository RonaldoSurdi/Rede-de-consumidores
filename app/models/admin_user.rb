class AdminUser < User
  def tipo
    "Administrador"
  end

  def self.master
    AdminUser.order(:id).first
  end
end