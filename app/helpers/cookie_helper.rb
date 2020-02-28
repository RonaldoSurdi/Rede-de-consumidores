module CookieHelper
  def gravar_cidade_default(cidade_id)
    cookies[:cidade_default] = {
      value: cidade_id,
      expires: 1.year.from_now
    }
  end

  def gravar_indicante(id, email)
    indicante = {
      id: id,
      email: email
    }
    cookies[:indicante] = {
      value: indicante.to_json,
      expires: 1.year.from_now
    }
  end

  def indicante
    HashWithIndifferentAccess.new JSON.parse(cookies[:indicante]) if cookies[:indicante]
  end

  def cidade_default
    cookies[:cidade_default]
  end

  def deletar_indicante
    cookies.delete :indicante
  end
end