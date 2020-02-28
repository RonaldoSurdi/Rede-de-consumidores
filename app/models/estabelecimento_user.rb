class EstabelecimentoUser < User
  validate :has_cities?
  validates_presence_of :juridica_fisica, :cpf_cnpj, :logradouro, :numero, :bairro, :telefone, :cep, :percentual_bonus, :percentual_bonus_outras_formas
  validates_uniqueness_of :cpf_cnpj

  has_many :operadores

  has_attached_file :logo,  :styles => {thumb: "88x52#", medium: "236x140#"}
  validates_attachment :logo,
                       presence: true,
                       content_type: { content_type: ["image/jpg", "image/jpeg", "image/gif", "image/png"] }

  def tipo
    "Estabelecimento"
  end

  def has_cities?
    errors.add(:cities, "Cidade não pode ficar em branco") if self.cities.to_a.length != 1
  end

  def percentual_bonus=(percentual_bonus)
    percentual_bonus = percentual_bonus.safe_to_f unless percentual_bonus.is_a? Float
    write_attribute(:percentual_bonus, percentual_bonus)
  end

  def percentual_bonus_outras_formas=(percentual_bonus_outras_formas)
    percentual_bonus_outras_formas = percentual_bonus_outras_formas.safe_to_f unless percentual_bonus_outras_formas.is_a? Float
    write_attribute(:percentual_bonus_outras_formas, percentual_bonus_outras_formas)
  end

  def taxa_publicidade=(taxa_publicidade)
    taxa_publicidade = taxa_publicidade.safe_to_f unless taxa_publicidade.is_a? Float
    write_attribute(:taxa_publicidade, taxa_publicidade)
  end
end