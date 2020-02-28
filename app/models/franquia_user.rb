class FranquiaUser < User
  validate :has_cities?, :existing_cities?
  validates_presence_of :juridica_fisica, :cpf_cnpj, :logradouro, :numero, :bairro, :telefone, :cep
  validates_uniqueness_of :cpf_cnpj
  has_one :config_pagseguro

  def tipo
    "Franquia"
  end

  def has_cities?
    errors.add(:cities, "Você deve informar no mínimo uma cidade") if self.cities.to_a.empty?
  end

  def existing_cities?
    query = FranquiaUser.joins(:cities).where("cities.id in (?)", self.cities.to_a)
    query = query.where("users.id != ?", self.id) if self.id
    errors.add(:cities, "Já existem Franquias nas cidades selecionadas") if query.take
  end
end