class PagSeguroFactory

  def self.create!(pagamento, url_redirect)
    raise "Pagamento sem ID" unless pagamento.id

    payment = PagSeguro::PaymentRequest.new
    payment.sender = {
      name: pagamento.origem.nome,
      email: pagamento.origem.email,
      cpf: pagamento.origem.cpf_cnpj
    }
    payment.reference = pagamento.id
    payment.redirect_url = Rails.env.production? ? url_redirect : "http://tnms.no-ip.org:7070/"
    payment.email = pagamento.destino.config_pagseguro.email
    payment.token = pagamento.destino.config_pagseguro.token
    payment.items << {
        id: 1,
        description: "Anuidade Rede ConsumerCard",
        amount: pagamento.valor.to_f
     }

    shipping_options = {
      type_name: "not_specified",
      address: {
        street: pagamento.origem.logradouro,
        number: pagamento.origem.numero,
        complement: pagamento.origem.complemento,
        district: pagamento.origem.bairro,
        city: pagamento.origem.cidade,
        state: pagamento.origem.uf,
        postal_code: pagamento.origem.cep
      }
    }
    payment.shipping = PagSeguro::Shipping.new(shipping_options)

    response = payment.register
    raise response.errors.join("\n") if response.errors.any?
    response
  end
end