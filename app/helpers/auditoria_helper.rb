module AuditoriaHelper
  def acao_auditoria(activity)
    if activity.key =~ /.*update.*/
     "Alterou"
    elsif activity.key =~ /.*create.*/
      "Criou"
    elsif activity.key =~ /.*destroy.*/
      "Deletou"
    end
  end
end