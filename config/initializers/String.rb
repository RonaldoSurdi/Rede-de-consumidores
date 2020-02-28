class String

  def safe_to_f
    to_str_number.to_f
  end

  def safe_to_big_decimal
    BigDecimal.new(to_str_number)
  end

  def remover_acentos
    ret = gsub(/(á|à|ã|â|ä)/, 'a').gsub(/(é|è|ê|ë)/, 'e').gsub(/(í|ì|î|ï)/, 'i').gsub(/(ó|ò|õ|ô|ö)/, 'o').gsub(/(ú|ù|û|ü)/, 'u')
    ret = ret.gsub(/(Á|À|Ã|Â|Ä)/, 'A').gsub(/(É|È|Ê|Ë)/, 'E').gsub(/(Í|Ì|Î|Ï)/, 'I').gsub(/(Ó|Ò|Õ|Ô|Ö)/, 'O').gsub(/(Ú|Ù|Û|Ü)/, 'U')
    ret = ret.gsub(/ñ/, 'n').gsub(/Ñ/, 'N')
    ret = ret.gsub(/ç/, 'c').gsub(/Ç/, 'C')
    ret
  end

  def nl2br
    self.gsub(/\n/, '<br/>')
  end

  private

  def to_str_number
    self.gsub(/R|\$|\./, '').gsub(",",".").strip
  end

end