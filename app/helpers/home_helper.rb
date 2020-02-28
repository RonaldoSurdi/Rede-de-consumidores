module HomeHelper
  def message_config_boleto
    if [FranquiaUser,AdminUser].include? current_user.class
      "Verifique as configurações para emissão de boleto" if !current_user_unico_admin.config_boleto
    end
  end

  def message_config_pagseguro
    "Verifique as configurações do PagSeguro" if current_user_unico_admin.is_a?(FranquiaUser) && !current_user_unico_admin.config_pagseguro
  end
end
