class ConfigBoleto < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller ? controller.current_user : nil }

  belongs_to :user

  @@bancos = {
    bb: {descricao: "Banco do Brasil", classe: Brcobranca::Boleto::BancoBrasil},
    bradesco: {descricao: "Bradesco", classe: Brcobranca::Boleto::Bradesco},
    caixa: {descricao: "Caixa Econômica Federal", classe: Brcobranca::Boleto::Caixa},
    itau: {descricao: "Itaú", classe: Brcobranca::Boleto::Itau},
    sicredi: {descricao: "Sicredi", classe: Brcobranca::Boleto::Sicredi}
  }

  validates_presence_of :banco, :convenio, :agencia, :conta_corrente, :dias_vencimento, :instrucoes, :user

  def self.bancos
    @@bancos
  end
end
