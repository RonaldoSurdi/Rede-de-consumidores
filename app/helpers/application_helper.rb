module ApplicationHelper
  def get_class_control_form(model, attribute)
    ret = ['form-group']
    ret << 'has-error'  if (model.errors.messages || [])[attribute.to_sym]
    ret.join ' '
  end

  def breadcrumb
    render partial: "general/breadcrumb"
  end

  def messages
    render partial: "general/messages"
  end

  def scope_admin?
    request.original_url =~ /.+(\/admin).*/
  end

  def scope_estabelecimento?
    request.original_url =~ /\/e\/.*?/
  end

  def layout
    if scope_admin?
      user_signed_in? ? "layouts/admin.html.erb" : "layouts/admin_public.html.erb"
    elsif scope_estabelecimento?
      "layouts/admin_public.html.erb"
    else
      "layouts/public.html.erb"
    end
  end

  def periodo_options
    [
      ["Personalizado", ""],
      ["Dia", "DIA"],
      ["Semana Atual", "SEMANA_ATUAL"],
      ["Semana Anterior", "SEMANA_ANTERIOR"],
      ["Mês Atual", "MES_ATUAL"],
      ["Mês Anterior", "MES_ANTERIOR"],
      ["Ano Atual", "ANO_CORRENTE"],
    ]
  end

  def current_user_unico_admin
    return AdminUser.master if current_user.is_a? AdminUser
    current_user
  end

  def current_cidade
    City.find(cookies[:cidade_default]) if cookies[:cidade_default]
  end

  def saudacao(user)
    user.sexo == "Feminino" ? "Bem Vinda" : "Bem Vindo"
  end
end