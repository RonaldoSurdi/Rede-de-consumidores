module UsersHelper
  def cidade_label(user)
    if user.is_a? ClienteUser
      "Cidade de Consumo"
    else
      "Cidade"
    end
  end
end
