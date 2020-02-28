class Parametrizacao < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller ? controller.current_user : nil }

  validates_presence_of :percentual_cliente, :percentual_franquia, :percentual_indicado, :vlr_minimo_bonus_indicacao
  validate :deve_somar_100

  def percentual_cliente=(percentual_cliente)
    to_float :percentual_cliente, percentual_cliente
  end

  def percentual_franquia=(percentual_franquia)
    to_float :percentual_franquia, percentual_franquia
  end

  def percentual_indicado=(percentual_indicado)
    to_float :percentual_indicado, percentual_indicado
  end

  def vlr_minimo_bonus_indicacao=(vlr_minimo_bonus_indicacao)
    to_float :vlr_minimo_bonus_indicacao, vlr_minimo_bonus_indicacao
  end

  def percentual_administracao=(percentual_administracao)
    to_float :percentual_administracao, percentual_administracao
  end

  def vlr_consumo_medio_para_resgate_premios=(vlr_consumo_medio_para_resgate_premios)
    to_float :vlr_consumo_medio_para_resgate_premios, vlr_consumo_medio_para_resgate_premios
  end  

  def valor_cartao=(valor_cartao)
    to_float :valor_cartao, valor_cartao
  end

  private

  def to_float(attribute, vlr)
    vlr = vlr.safe_to_f if vlr.is_a? String
    write_attribute(attribute, vlr)
  end

  def deve_somar_100
    soma = self.percentual_cliente + self.percentual_indicado + self.percentual_franquia
    errors.add(:percentual_cliente, "A soma dos percentuais deve ser igual a 100%") if soma != 100
  end
end