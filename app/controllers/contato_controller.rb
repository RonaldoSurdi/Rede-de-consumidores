class ContatoController < ApplicationController

	def index
    @cidades = City.somente_cidades_com_franquia
    @infos = if cliente_user_signed_in?
      {
        nome: current_cliente_user.nome,
        email: current_cliente_user.email,
        telefone: current_cliente_user.celular,
        assunto: params[:assunto],
      }
    else
      {}
    end
	end

  def create
    ContatoMailer.contato(params[:contato]).deliver
    redirect_to contato_index_path, notice: "Mensagem enviada com sucesso!"
  end

end