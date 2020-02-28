module Admin::AnuidadesHelper
  def tr_class_anuidade(anuidade)
    if anuidade.status.to_sym == :pago
      "success"
    else
      "warning"
    end
  end
end
