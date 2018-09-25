module FidorApi
  module Model
    module Transfer
      class Generic < Model::Base
        SUPPORTED_ROUTING_TYPES = {
          'SEPA'             => %w[remote_iban remote_bic],
          'FOS_P2P_EMAIL'    => %w[email],
          'FOS_P2P_PHONE'    => %w[mobile_phone_number],
          'FOS_P2P_USERNAME' => %w[username],
          'FPS'              => %w[remote_account_number remote_sort_code]
        }.freeze

        attribute :id,           :string
        attribute :account_id,   :string
        attribute :external_uid, :string
        attribute :amount,       :integer
        attribute :currency,     :string
        attribute :subject,      :string
        attribute :beneficiary,  :json
        attribute :state,        :string

        attribute_decimal_methods :amount

        def self.resource_name
          'Transfer'
        end

        def beneficiary=(value)
          write_attribute(:beneficiary, value)
          define_methods_for(beneficiary['routing_type'])
        end

        def routing_type
          @beneficiary ||= {}
          @beneficiary.dig('routing_type')
        end

        def routing_type=(type)
          raise Errors::NotSupported unless SUPPORTED_ROUTING_TYPES.key?(type)

          @beneficiary ||= {}
          @beneficiary['routing_type'] = type
          define_methods_for(type)
        end

        def define_methods_for(type) # rubocop:disable Metrics/MethodLength
          SUPPORTED_ROUTING_TYPES[type].each do |name|
            next if respond_to?(name)

            self.class.define_method name do
              @beneficiary ||= {}
              @beneficiary.dig('routing_info', name)
            end

            self.class.define_method "#{name}=" do |value|
              @beneficiary ||= {}
              @beneficiary['routing_info'] ||= {}
              @beneficiary['routing_info'][name] = value
            end
          end
        end

        %w[bank contact].each do |category|
          %w[name address_line_1 address_line_2 city country].each do |attribute|
            define_method "#{category}_#{attribute}" do
              @beneficiary ||= {}
              @beneficiary.dig(category, attribute)
            end

            define_method "#{category}_#{attribute}=" do |value|
              @beneficiary ||= {}
              @beneficiary[category] ||= {}
              @beneficiary[category][attribute] = value
            end
          end
        end

        def parse_errors(body)
          body['errors'].each do |hash|
            hash['field'].sub!('beneficiary.routing_info.', '')
          end
          super(body)
        end
      end
    end
  end
end
