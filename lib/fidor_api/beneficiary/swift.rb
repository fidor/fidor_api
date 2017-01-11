module FidorApi
  module Beneficiary
    class Swift < Base
      include Generic

      attribute :account_number,   :string
      attribute :swift_code,       :string
      attribute :account_currency, :string

      validates :account_number,   presence: true
      validates :swift_code,       presence: true
      validates :contact_name,     presence: true
      validates :account_currency, presence: true

      def set_attributes(attrs = {})
        self.account_number   = attrs.fetch("routing_info", {})["account_number"]
        self.swift_code       = attrs.fetch("routing_info", {})["swift_code"]
        self.account_currency = attrs.fetch("routing_info", {})["account_currency"]
        super(attrs.except("routing_type", "routing_info"))
      end

      def as_json_routing_type
        "SWIFT"
      end

      def as_json_routing_info
        {
          account_number:   account_number,
          swift_code:       swift_code,
          account_currency: account_currency
        }
      end
    end
  end
end
