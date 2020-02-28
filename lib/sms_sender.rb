class SmsSender
  include HTTParty

  base_uri "http://sms.consumercard.net/"

  def initialize(telefone, mensagem)
    @telefone = telefone.gsub(/\D/, "")
    @mensagem = mensagem.remover_acentos
  end

  def send
    data = {message: {
      to: @telefone,
      message: @mensagem,
      status: 2
    }, device: "358812040824795"}.to_json

    options = {
      body: data,
      headers: {
        "Aceept" => "application/json",
        "Content-Type" => "application/json",
        "Authorization" => "Basic YWRtaW5Ad29sZi5jb20uYnI6Y29ubmVjdDEyMw=="
      }
    }

    self.class.post("/api/messages.json", options)
  end
end
