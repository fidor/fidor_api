require 'fidor_api/model/beneficiary_helper'

module FidorApi
  module Model
    module Transfer
      class Generic < Model::Base
        include BeneficiaryHelper

        attribute :id,             :string
        attribute :account_id,     :string
        attribute :external_uid,   :string
        attribute :amount,         :integer
        attribute :currency,       :string
        attribute :subject,        :string
        attribute :beneficiary,    :json
        attribute :state,          :string
        attribute :scheduled_date, :string

        attribute_decimal_methods :amount

        def self.resource_name
          'Transfer'
        end

        def beneficiary=(value)
          write_attribute(:beneficiary, value)
          define_methods_for(SUPPORTED_ROUTING_TYPES[beneficiary['routing_type']])
        end

        def routing_type
          @beneficiary ||= {}
          @beneficiary.dig('routing_type')
        end

        def routing_type=(type)
          raise Errors::NotSupported unless SUPPORTED_ROUTING_TYPES.key?(type)

          @beneficiary ||= {}
          @beneficiary['routing_type'] = type
          define_methods_for(SUPPORTED_ROUTING_TYPES[type])
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
      end
    end
  end
end
