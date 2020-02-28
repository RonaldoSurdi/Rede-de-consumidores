class Ability
  include CanCan::Ability

  def initialize(user)
    can :access, "admin/sessions"
    can :access, "e/sessions"
    if user
      if user.is_a? AdminUser
        can :access, :all
      elsif user.is_a? FranquiaUser
        can :access, "admin/home"
        can :access, "admin/estabelecimento_users"
        can :access, "admin/config_boletos"
        can :access, "admin/movimentos"
        can :access, "admin/pagamentos"
        can :access, "admin/boletos"
        can :access, "admin/cliente_users"
        can :access, "admin/auditoria"
        can :access, "admin/banners"
        can :access, "admin/anuidades"
        can :access, "admin/config_pagseguros"
        can :access, "admin/indicacoes_admin"
        can :access, "admin/password"
        can :access, "admin/transacoes"
        can :access, "admin/importacoes"
      elsif user.is_a? EstabelecimentoUser
        can :access, "admin/home"
        can :access, "admin/operadores"
        can :access, "admin/movimentos"
        can :access, "admin/transacoes"
        can :access, "admin/pagamentos"
        can :access, "admin/boletos"
        can :access, "admin/auditoria"
        can :access, "admin/banners"
        can :access, "admin/password"
      elsif user.is_a? Operador
        can :access, "e/home"
      end
    end
  end
end
