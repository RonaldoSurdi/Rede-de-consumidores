class Fechamentos

  def get_transacoes
    Transacao.por_periodo(@data_inicio, @data_fim).order(:id).to_a
  end

  def do(data_base)
    @data_inicio = data_base.beginning_of_month.beginning_of_day.to_date
    @data_fim = data_base.end_of_month.end_of_day.to_date
    @parametrizacao = Parametrizacao.first
    @str_base = "Fechamento Ref. ao Mês #{@data_inicio.month}/#{@data_inicio.year}"
    @data_lancamento = @data_inicio + 1.month
    @fechamento_mes_base = @data_inicio.month
    @fechamento_ano_base = @data_inicio.year

    gerar_valores_transacoes
    gerar_movimentos
  end

  private

  def gerar_valores_transacoes
    @cache_bonus = {}
    transacoes = get_transacoes
    transacoes.each do |transacao|
      unless transacao.cancelada
        padrinho = transacao.cliente_user.padrinho
        percentual_franquia = @parametrizacao.percentual_franquia + @parametrizacao.percentual_indicado
        percentual_indicado = 0.0
        if padrinho
          @cache_bonus[padrinho.id] = Transacao.somar(transacao.cliente_user.padrinho, @data_inicio.at_beginning_of_day, @data_fim) >= @parametrizacao.vlr_minimo_bonus_indicacao if @cache_bonus[padrinho.id].nil?

          if @cache_bonus[padrinho.id]
            percentual_franquia = @parametrizacao.percentual_franquia
            percentual_indicado = @parametrizacao.percentual_indicado
          end
        end

        if transacao.forma_pagamento.to_sym == :pontos
          if padrinho
            vlr_bonus = transacao.vlr_gasto * (transacao.percentual_bonus/100.0)
            transacao.valor_franquia = vlr_bonus * ((100.0 - percentual_indicado)/100.0)
            transacao.valor_padrinho = vlr_bonus * (percentual_indicado/100.0)
          else
            transacao.valor_franquia = transacao.vlr_gasto * (transacao.percentual_bonus/100.0)
          end
        else
          transacao.valor_franquia = transacao.vlr_gasto * (transacao.percentual_bonus/100.0) * (percentual_franquia/100.0)
          transacao.valor_padrinho = transacao.vlr_gasto * (transacao.percentual_bonus/100.0) * (percentual_indicado/100.0)
        end
      else
        transacao.valor_franquia = 0.0
        transacao.valor_padrinho = 0.0
      end
      transacao.save!
    end
  end

  def gerar_movimentos
    totais = Transacao.por_periodo(@data_inicio, @data_fim)
              .select("Sum(valor_franquia) total_franquia, Sum(valor_padrinho) total_padrinho, users.id estabelecimento_id, users.nome estabelecimento_nome")
              .joins(operador: :estabelecimento_user)
              .group("users.id")
              .to_a

    valores_franquia = {}
    valores_estabelecimento = {}

    totais.each do |total|
      total_geral = total.total_franquia + (total.total_padrinho || BigDecimal.new("0"))
      valores_estabelecimento[total.estabelecimento_id] ||= {}
      valores_estabelecimento[total.estabelecimento_id] = BigDecimal.new("-#{total_geral.to_s}")

      valores_franquia[total.estabelecimento_id] ||= {}
      valores_franquia[total.estabelecimento_id] = {
        estabelecimento_id: total.estabelecimento_id,
        estabelecimento_nome: total.estabelecimento_nome,
        total: total.total_franquia
      }
    end

    totais = Movimento
              .select("Sum(movimentos.vlr) total, users.id estabelecimento_id")
              .joins(:transacao).joins(transacao: "operador").joins(transacao: {operador: "estabelecimento_user"})
              .where("transacoes.created_at Between ? And ?", @data_inicio.at_beginning_of_day, @data_fim.at_end_of_day)
              .group("users.id")
              .to_a
    totais.each do |total|
      valores_estabelecimento[total.estabelecimento_id] ||= BigDecimal.new("0")
      valores_estabelecimento[total.estabelecimento_id] -= total.total
    end

    cache_franquias = {}

    valores_franquia.each do |estabelecimento_id, total|
      franquia = EstabelecimentoUser.find(estabelecimento_id).franquia
      raise "Franquia não encontrada para o estabelecimento de código #{total.estabelecimento_id}" unless franquia
      cache_franquias[estabelecimento_id] = franquia
      if total[:total].to_f != 0.0
        m = Movimento.new
        m.data = @data_lancamento
        m.vlr = total[:total]
        m.user = franquia
        m.descricao = "#{@str_base} - Comissão s/ vendas do Estabelecimento #{total[:estabelecimento_nome]}"
        m.fechamento_mes_base = @fechamento_mes_base
        m.fechamento_ano_base = @fechamento_ano_base
        m.save!
      end
    end

    valores_estabelecimento.each do |estabelecimento_id, total|
      m = Movimento.new
      m.data = @data_lancamento
      m.vlr = total
      m.user_id = estabelecimento_id
      m.descricao = "#{@str_base} - Bônus / Vendas"
      m.fechamento_mes_base = @fechamento_mes_base
      m.fechamento_ano_base = @fechamento_ano_base
      m.save!
    end

    gerar_movimento_ref_a_publicidade
    gerar_movimento_ref_a_padrinho
    gerar_movimento_para_administrador
  end

  def gerar_movimento_ref_a_publicidade
    EstabelecimentoUser.where("taxa_publicidade > 0").to_a.each do |estabelecimento|
      m = Movimento.new
      m.data = @data_lancamento
      m.vlr = -estabelecimento.taxa_publicidade
      m.user = estabelecimento
      m.descricao = "#{@str_base} - Taxa de Publicidade"
      m.fechamento_mes_base = @fechamento_mes_base
      m.fechamento_ano_base = @fechamento_ano_base
      m.save!

      m = Movimento.new
      m.data = @data_lancamento
      m.vlr = estabelecimento.taxa_publicidade
      m.user = estabelecimento.franquia
      m.descricao = "#{@str_base} - Taxa de Publicidade do Estabelecimento #{estabelecimento.nome}"
      m.fechamento_mes_base = @fechamento_mes_base
      m.fechamento_ano_base = @fechamento_ano_base
      m.save!
    end
  end

  def gerar_movimento_ref_a_padrinho
    totais = Transacao
              .por_periodo(@data_inicio, @data_fim)
              .select("Sum(Valor_Padrinho) total, padrinhos_users.id padrinho_id, users.nome cliente_nome")
              .joins(cliente_user: :padrinho)
              .group("padrinhos_users.id, users.id")
              .to_a

    totais.each do |total|
      if total.total > 0
        m = Movimento.new
        m.data = @data_lancamento
        m.vlr = total.total
        m.user_id = total.padrinho_id
        m.descricao = "#{@str_base} - Bônus de Compra de Indicado de #{total.cliente_nome}"
        m.fechamento_mes_base = @fechamento_mes_base
        m.fechamento_ano_base = @fechamento_ano_base
        m.save!
      end
    end
  end

  def gerar_movimento_para_administrador
    franquias = FranquiaUser.order(:id).to_a

    franquias.each do |franquia|
      saldo_fechamento = Movimento
        .where(user: franquia)
        .where(fechamento_mes_base: @fechamento_mes_base)
        .where(fechamento_ano_base: @fechamento_ano_base)
        .sum(:vlr)
        .truncate(2)
      saldo_franquia = Saldo.para(franquia).no_periodo_de(@data_inicio).ate(@data_fim).excluir_fechamentos.saldo + saldo_fechamento

      if saldo_franquia.to_f > 0.0
        valor = saldo_franquia * (@parametrizacao.percentual_administracao / 100.0)

        m = Movimento.new
        m.data = @data_lancamento
        m.vlr = -valor
        m.user = franquia
        m.descricao = "#{@str_base} - Comissão Administração"
        m.fechamento_mes_base = @fechamento_mes_base
        m.fechamento_ano_base = @fechamento_ano_base
        m.save!

        m = Movimento.new
        m.data = @data_lancamento
        m.vlr = valor
        m.user = AdminUser.master
        m.descricao = "#{@str_base} - Comissão Administração da Franquia #{franquia.nome}"
        m.fechamento_mes_base = @fechamento_mes_base
        m.fechamento_ano_base = @fechamento_ano_base
        m.save!

        p = Pagamento.new
        p.valor = valor.abs.truncate(2)
        p.origem = franquia
        p.destino = m.user
        p.save!
      end
    end
  end
end