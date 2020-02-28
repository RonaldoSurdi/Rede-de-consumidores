module Importation
  require 'csv'

  class CSVClientUser
    SEPARADORES = {
      virgula: { valor: 0, separador: ","},
      ponto_e_virgula: { valor: 1, separador: ";"},
      tab: { valor: 2, separador: "\t"}
    }

    VALOR_DECIMAL_REGEX = %r{^([0-9]+),([0-9]{1,2})$}
    VALOR_REGEX = %r{^([0-9]+)$}

    def initialize(current_user)
      @current_user = current_user
    end

    def generate(string, options = {})
      errors = []
      options = parse_defaults(options)

      csv = CSV.parse(string.force_encoding(options[:encoding]).encode(Encoding::UTF_8),
        col_sep: options[:col_sep],
        encoding: Encoding::UTF_8)

      ActiveRecord::Base.transaction do
        csv.each_with_index do |row, i|
          if row.select(&:present?).present?
            row[options[:columns][:cidade_consumo_id]] = find_city(row[options[:columns][:cidade_consumo]])
            format_values(row, options)

            attrs_to_assign = {
              nome:             row[options[:columns][:nome]],
              plano_adesao_id:  row[options[:columns][:plano_adesao_id]],
              email:            row[options[:columns][:email]],
              password:         row[options[:columns][:password]],
              juridica_fisica:  row[options[:columns][:juridica_fisica]],
              cpf_cnpj:         row[options[:columns][:cpf_cnpj]],
              cities:           row[options[:columns][:cidade_consumo_id]],
              cidade:           row[options[:columns][:cidade_endereco]],
              cep:              row[options[:columns][:cep]],
              logradouro:       row[options[:columns][:logradouro]],
              numero:           row[options[:columns][:numero]],
              bairro:           row[options[:columns][:bairro]],
              complemento:      row[options[:columns][:complemento]],
              celular:          row[options[:columns][:celular]],
              telefone:         row[options[:columns][:telefone]],
              padrinho_id:      options[:padrinho_id],
              importado:        true
            }

            attrs_to_assign.merge!({
              sexo: (row[options[:columns][:sexo]].try(:upcase) == "F") ? ClienteUser::SEXOS[:feminino] : ClienteUser::SEXOS[:masculino],
              estado_civil: ClienteUser::ESTADOS_CIVIS[row[options[:columns][:estado_civil]].to_i],
              data_nascimento: row[options[:columns][:data_nascimento]]
            }) if row[options[:columns][:juridica_fisica]].try(:upcase) == "F"

            cliente_user = ClienteUser.new(attrs_to_assign)
            cliente_user.skip_confirmation!
            cliente_user.skip_confirmation_notification!
            cliente_user.assign_attributes(attrs_to_assign)
            row_errors = {}
            row_errors = cliente_user.errors.messages unless cliente_user.save

            row_errors.merge!(custom_validations(row, options))
            row_errors.delete(:plano_adesao)

            errors << { (i + 1) => row_errors } if row_errors.any?

            if errors.empty?
              Rails.logger.info "Gerando anuidade - Cliente #{cliente_user.id}"
              pagamento = Pagamento.gerar_anuidade!(cliente_user, row[options[:columns][:plano_adesao_id]], :boleto, row[options[:columns][:valor_anuidade]])

              # Convertendo Valores
              valor_indicado = row[options[:columns][:valor_indicado]].gsub(',', '.').to_f
              pontos_indicacao = row[options[:columns][:pontos_indicacao]].gsub(',', '.').to_f

              pagamento.confirmar_anuidade! valor_indicado, pontos_indicacao if pagamento.valor.to_f == 0.0
            end
          end
        end

        raise Exception if errors.any?
      end

    rescue ArgumentError => e
      Rails.logger.fatal e.backtrace
      errors = [{ general: "Não foi possível ler o arquivo, tente usar outra codificação." }]
    rescue Exception => e
      Rails.logger.fatal e.backtrace
      if errors.blank?
        errors = [{ general: "Possuem erros no arquivo, verifique se o mesmo possui o formato e separação correta." }]
      end

    ensure
      return errors
    end


    private

    def parse_defaults(options)
      options[:encoding] ||= Encoding::UTF_8
      options[:col_sep] ||= ","
      options[:columns] ||= []
      options[:columns] = Hash[options[:columns].map.with_index.to_a]
      options[:columns].merge!({ cidade_consumo_id: options[:columns].size })

      options
    end

    def find_city(city_and_uf)
      split = city_and_uf.to_s.split('-')
      return [] if split.length != 2

      city = split.first.strip
      uf = split.last.strip

      (@current_user.is_a?(AdminUser) ? City : @current_user.cities).where(description: city, uf: uf).order(:id).limit(1)
    end

    def format_values(row, options)
      value = row[options[:columns][:cep]]

      if value.present?
        value.gsub!(/\D/, "")
        value.insert(value.size-3, "-") if value.size >= 3
      end
    end

    def custom_validations(row, options)
      row_errors = {}

      unless row[options[:columns][:juridica_fisica]].try(:upcase) == "F" || row[options[:columns][:juridica_fisica]].try(:upcase) == "J"
        row_errors[:juridica_fisica] ||= []
        row_errors[:juridica_fisica] << "formato inválido"
      end

      if row[options[:columns][:juridica_fisica]].try(:upcase) != "J"
        unless (row[options[:columns][:sexo]].try(:upcase) == "F" || row[options[:columns][:sexo]].try(:upcase) == "M")
          row_errors[:sexo] ||= []
          row_errors[:sexo] << "formato inválido"
        end

        unless (row[options[:columns][:estado_civil]] =~ /^\d$/) &&
                ClienteUser::ESTADOS_CIVIS.key?(row[options[:columns][:estado_civil]].to_i)

          row_errors[:estado_civil] ||= []
          row_errors[:estado_civil] << "valor inválido"
        end

        unless (DateTime.parse(row[options[:columns][:data_nascimento]]) rescue false)
          row_errors[:data_nascimento] ||= []
          row_errors[:data_nascimento] << "data inválida"
        end
      end


      unless (PlanosAdesao.where(id: row[options[:columns][:plano_adesao_id]]).exists?)
        row_errors[:plano_adesao_id] ||= []
        row_errors[:plano_adesao_id] << "valor inválido"
      end

      if row[options[:columns][:cidade_consumo]].present? && row[options[:columns][:cidade_consumo_id]].blank?
        row_errors[:cities] ||= []
        row_errors[:cities].unshift("não existe entre as cidades cadastradas")
      end

      row_errors[:valor_anuidade] = ["não pode ficar vazio"] if row[options[:columns][:valor_anuidade]].blank?
      row_errors[:valor_indicado] = ["não pode ficar vazio"] if row[options[:columns][:valor_indicado]].blank?
      row_errors[:pontos_indicacao] = ["não pode ficar vazio"] if row[options[:columns][:pontos_indicacao]].blank?

      row_errors[:valor_anuidade] = ["não pode ser menor que zero"] if row_errors[:valor_anuidade].blank? && (row[options[:columns][:valor_anuidade]].to_i < 0)
      row_errors[:valor_indicado] = ["não pode ser menor que zero"] if row_errors[:valor_indicado].blank? && (row[options[:columns][:valor_indicado]].to_i < 0)
      row_errors[:pontos_indicacao] = ["não pode ser menor que zero"] if row_errors[:pontos_indicacao].blank? && (row[options[:columns][:pontos_indicacao]].to_i < 0)

      row_errors[:valor_anuidade] = ["formato inválido"] if row_errors[:valor_anuidade].blank? && !(row[options[:columns][:valor_anuidade]] =~ VALOR_DECIMAL_REGEX)
      row_errors[:valor_indicado] = ["formato inválido"] if row_errors[:valor_indicado].blank? && !(row[options[:columns][:valor_indicado]] =~ VALOR_DECIMAL_REGEX)
      row_errors[:pontos_indicacao] = ["formato inválido"] if row_errors[:pontos_indicacao].blank? && !(row[options[:columns][:pontos_indicacao]] =~ VALOR_REGEX)

      row_errors
    end
  end
end