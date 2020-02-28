class PlanosAdesao < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller ? controller.current_user : nil }
  
  validates_presence_of :vlr_anuidade, :vlr_indicado, :descricao
  #validate :validate_valor_indicado
  scope :pessoal, -> { where(descricao: "Pessoal") }

  def vlr_anuidade=(vlr_anuidade)
    vlr_anuidade = vlr_anuidade.safe_to_f unless vlr_anuidade.is_a? Float
    write_attribute(:vlr_anuidade, vlr_anuidade)
  end

  def vlr_indicado=(vlr_indicado)
    vlr_indicado = vlr_indicado.safe_to_f unless vlr_indicado.is_a? Float
    write_attribute(:vlr_indicado, vlr_indicado)
  end

  def advanced?
    self.descricao.downcase == "consumercard advanced"
  end

  def self.advanced
    PlanosAdesao.where(descricao: "ConsumerCard Advanced").first
  end

  def self.basico
    PlanosAdesao.where(descricao: "ConsumerCard").first
  end

  private

  def validate_valor_indicado
    errors.add(:vlr_indicado, "Valor do indicado deve ser menor que o valor da anuidade") if vlr_indicado > vlr_anuidade
  end
end