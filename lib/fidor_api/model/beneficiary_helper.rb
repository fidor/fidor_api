module FidorApi
  module Model
    module BeneficiaryHelper
      SUPPORTED_ROUTING_TYPES = {
        'SEPA'                   => %w[remote_iban remote_bic],
        'FOS_P2P_EMAIL'          => %w[email],
        'FOS_P2P_PHONE'          => %w[mobile_phone_number],
        'FOS_P2P_ACCOUNT_NUMBER' => %w[account_number],
        'FOS_P2P_USERNAME'       => %w[username],
        'FPS'                    => %w[remote_account_number remote_sort_code]
      }.freeze

      def define_methods_for(properties) # rubocop:disable Metrics/MethodLength
        properties.each do |name|
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

      def parse_errors(body)
        body['errors'].each do |hash|
          hash['field'].sub!('beneficiary.routing_info.', '')
        end
        super(body)
      end
    end
  end
end
