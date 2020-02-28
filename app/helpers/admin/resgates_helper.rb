module Admin::ResgatesHelper
  def tr_class_resgate(resgate)
    resgate.enviado ? "success" : "warning"
  end
end
