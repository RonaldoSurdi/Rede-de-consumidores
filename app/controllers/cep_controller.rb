class CepController < ApplicationController
  def show
    @cep = BuscaEndereco.cep(params[:id])
  rescue
    @cep = {}
    @erro = "A busca de endereço por CEP está indisponível, por favor, informe o nome de sua cidade."
  end
end