class Saldo
  @@lock = {}

  def initialize(usuario)
    @@lock[usuario.id] ||= Mutex.new
    @usuario = usuario
  end

  def self.para(usuario)
    Saldo.new usuario
  end

  def no_periodo_de(data_inicial)
    @data_inicial = data_inicial
    self
  end

  def ate(data_final)
    @data_final = data_final
    self
  end

  def tem_direito_bonus_indicacao?
    Parametrizacao.first.vlr_minimo_bonus_indicacao <= saldo
  end

  def excluir_fechamentos
    @excluir_fechamentos = true
    self
  end

  def saldo
    @@lock[@usuario.id].synchronize do
      if @data_inicial && @data_final
        Movimento.saldo(@usuario, @data_inicial.to_date, @data_final.to_date, @excluir_fechamentos).truncate(2)
      else
        Movimento.saldo_total(@usuario).truncate(2)
      end
    end
  end
end