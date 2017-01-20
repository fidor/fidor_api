module FidorApi
  module CardLimitAttribute
    def self.included(base)
      base.attribute :limits, :json
      base.validate :validate_limits
    end

    def method_missing(symbol, *args)
      if m = symbol.to_s.match(/(.*)_limit$/)
        limits[m[1]]
      elsif m = symbol.to_s.match(/(.*)_limit=$/)
        write_limit(m[1], args[0])
      else
        super
      end
    end

    def respond_to_missing?(symbol, include_all = false)
      if symbol.to_s =~ /.*_limit=?$/
        return true
      else
        super
      end
    end

    private

    def write_limit(key, value)
      self.limits ||= {}
      # If the client is using BigDecimal, we will cast it to cents for him
      if value.instance_of?(BigDecimal)
        self.limits[key] = (value * 100.00).to_i
      else
        self.limits[key] = value
      end
    end

    def validate_limits
      limits.each do |key, value|
        if value.instance_of?(BigDecimal)
          limits[key] = (value * 100.00).to_i
        elsif !(value.class.name.in?(INTEGER_CLASSES) || value.instance_of?(NilClass))
          errors.add(:"#{key}_limit", :not_an_integer)
          next
        end
        if limits[key] < 0
          errors.add(:"#{key}_limit", :greater_than_or_equal_to, count: 0)
        end
      end if limits
    end
  end
end
