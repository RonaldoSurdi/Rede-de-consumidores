# encoding: utf-8

class UF
  @@uf = {
    AC: "Acre",
    AL: "Alagoas",
    AM: "Amazonas",
    AP: "Amapá",
    BA: "Bahia",
    CE: "Ceará",
    DF: "Distrito Federal",
    ES: "Espírito Santo",
    GO: "Goiás",
    MA: "Maranhão",
    MT: "Mato Grosso",
    MS: "Mato Grosso do Sul",
    MG: "Minas Gerais",
    PA: "Pará",
    PB: "Paraíba",
    PR: "Paraná",
    PE: "Pernambuco",
    PI: "Piauí",
    RJ: "Rio de Janeiro",
    RN: "Rio Grande do Norte",
    RO: "Rondônia",
    RS: "Rio Grande do Sul",
    RR: "Roraima",
    SC: "Santa Catarina",
    SE: "Sergipe",
    SP: "São Paulo",
    TO: "Tocantins"
  }

  def self.all
    @@uf
  end
  
  def self.somente_com_cidade
    ret = {}
    
    City.select("distinct uf").order(:uf).each do |city|
      ret[city.uf.to_sym] = @@uf[city.uf.to_sym]
    end
    
    ret
  end
end