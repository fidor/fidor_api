module FidorApi
  module Model
    module Helpers
      module AttributeDecimalMethods
        # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        def attribute_decimal_methods(name)
          define_method name do
            value = read_attribute(name)
            return if value.nil?
            BigDecimal((value / 100.0).to_s)
          end

          define_method "#{name}=" do |value|
            case value
            when String
              value = (BigDecimal(value) * 100.0).to_i
            when Integer
              value = value
            when BigDecimal
              value = (value * 100.0).to_i
            else
              raise ArgumentError
            end

            write_attribute(name, value)
          end
        end
        # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
      end
    end
  end
end
