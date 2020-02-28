module ImportacoesHelper
  def clientes
    if current_user.is_a?(AdminUser)
      ClienteUser.order(:nome)
    else
      ClienteUser
        .joins(:cities)
        .where('cities.id' => current_user.cities)
        .order(:nome)
    end
  end
end