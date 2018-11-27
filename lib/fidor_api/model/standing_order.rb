require 'fidor_api/model/beneficiary_helper'

module FidorApi
  module Model
    class StandingOrder < Model::Base
      include BeneficiaryHelper

      attribute :id,           :string
      attribute :account_id,   :string
      attribute :external_uid, :string
      attribute :amount,       :integer
      attribute :currency,     :string
      attribute :subject,      :string
      attribute :beneficiary,  :json
      attribute :schedule,     :json

      attribute_decimal_methods :amount

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

      %w[rhythm runtime_day_of_month runtime_day_of_week ultimate_run].each do |attribute|
        define_method attribute do
          @schedule ||= {}
          @schedule[attribute]
        end

        define_method "#{attribute}=" do |value|
          @schedule ||= {}
          @schedule[attribute] = value
        end
      end
    end
  end
end
