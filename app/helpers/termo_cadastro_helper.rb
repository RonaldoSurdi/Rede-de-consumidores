module TermoCadastroHelper
  def termo_aprovado?
    session[:termo_aprovado]
  end

  def aprovar_termo!
    session[:termo_aprovado] = true
  end

  def rejeitar_termo!
    session[:termo_aprovado] = false
  end
end
