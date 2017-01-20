module FidorApi
  module AmountAttributes

    def self.extended(base)
      base.instance_variable_set('@amount_attributes', [])
    end

    def amount_attribute(name)
      @amount_attributes << name

      define_method name do
        BigDecimal.new((instance_variable_get("@#{name}") / 100.00).to_s) if instance_variable_get("@#{name}").present?
      end

      define_method "#{name}=" do |value|
        if value.instance_of?(BigDecimal)
          instance_variable_set("@#{name}", (value * 100.00).to_i)
        elsif value.class.name.in?(INTEGER_CLASSES) || value.instance_of?(NilClass)
          instance_variable_set("@#{name}", value)
        else
          raise ArgumentError, "Must be either Fixnum (1234) or BigDecimal (12.34)."
        end
      end
    end

    def attributes
      super + @amount_attributes
    end
  end
end
