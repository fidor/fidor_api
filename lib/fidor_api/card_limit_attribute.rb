module CardLimitAttribute
  def self.included(base)
    base.attribute :limits, :json
  end

  def method_missing(symbol, *args)
    if m = symbol.to_s.match(/(.*)_limit$/)
      limits[m[1]] && BigDecimal.new((limits[m[1]]/100).to_s)
    elsif m = symbol.to_s.match(/(.*)_limit=$/)
      self.limits ||= {}
      self.limits[m[1]] = args[0].to_i * 100
    else
      super
    end
  end

  def respond_to?(symbol, include_private=false)
    if symbol.to_s =~ /.*_limit=?$/
      return true
    else
      super
    end
  end
end
