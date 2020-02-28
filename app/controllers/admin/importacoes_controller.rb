class Admin::ImportacoesController < Admin::AdminController
  before_action :set_separador, only: [:create]
  before_action :set_codificacoes

  def create
    options = {
      col_sep: @separador,
      encoding: @codificacoes[params[:tipo_codificacao].to_i],
      padrinho_id: params[:padrinho_id]
    }

    erros = Importation::CSVClientUser.new(current_user)
              .generate(params[:arquivo].read, options.merge({columns: ordered_columns}))

    if erros.blank?
      flash[:notice] = "Importação de contatos realizada com sucesso!"
      redirect_to new_importacao_path
    else
      @erros = erros
      render :new
    end
  end

  private

  def set_separador
    if params[:tipo_arquivo].to_i == Importation::CSVClientUser::SEPARADORES[:tab][:valor]
      @separador = Importation::CSVClientUser::SEPARADORES[:tab][:separador]
    elsif params[:tipo_arquivo].to_i == Importation::CSVClientUser::SEPARADORES[:ponto_e_virgula][:valor]
      @separador = Importation::CSVClientUser::SEPARADORES[:ponto_e_virgula][:separador]
    else
      @separador = Importation::CSVClientUser::SEPARADORES[:virgula][:separador]
    end
  end

  def set_codificacoes
    @codificacoes = [
      Encoding::ISO_8859_1,
      Encoding::UTF_8
    ]
  end

  def ordered_columns
    [:nome, :email, :password, :cpf_cnpj, :cidade_consumo, :cidade_endereco, :cep, :logradouro, :numero, :bairro, :complemento,
      :celular, :telefone, :valor_anuidade, :valor_indicado, :pontos_indicacao, :juridica_fisica,
      :plano_adesao_id, :sexo, :estado_civil, :data_nascimento]
  end
end