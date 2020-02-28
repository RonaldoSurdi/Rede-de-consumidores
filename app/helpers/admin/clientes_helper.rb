module Admin::ClientesHelper
  def tr_class_cliente(user)
    if user.ultimo_pagamento && (user.ultimo_pagamento + 1.year).to_date >= DateTime.now.to_date
      "success"
    else
      "danger"
    end
  end
end
