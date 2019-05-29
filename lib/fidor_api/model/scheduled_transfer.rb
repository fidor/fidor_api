require_relative './beneficiary_helper'

module FidorApi
  module Model
    class ScheduledTransfer < Model::Base
      include FidorApi::Model::BeneficiaryHelper

      attribute :id,   :string
      attribute :account_id, :integer
      attribute :external_uid, :string
      attribute :currency, :string
      attribute :subject, :string
      attribute :status, :string
      attribute :beneficiary, :json
      attribute :amount, :integer
      attribute :scheduled_date, :string

      attribute_decimal_methods :amount

      def beneficiary=(value)
        write_attribute(:beneficiary, value)
        define_methods_for(SUPPORTED_ROUTING_TYPES[beneficiary['routing_type']])
      end

      def routing_type
        @beneficiary ||= {}
        @beneficiary.dig('routing_type')
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
