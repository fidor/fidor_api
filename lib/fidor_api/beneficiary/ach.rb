module FidorApi
  module Beneficiary
    class ACH < Base
      include Generic

      attribute :account_number, :string
      attribute :routing_code,   :string

      validates :contact_name,   presence: true
      validates :account_number, presence: true
      validates :routing_code,   presence: true

      def set_attributes(attrs = {})
        self.account_number = attrs.fetch("routing_info", {})["account_number"]
        self.routing_code   = attrs.fetch("routing_info", {})["routing_code"]
        super(attrs.except("routing_type", "routing_info"))
      end

      def as_json_routing_type
        "ACH"
      end

      def as_json_routing_info
        {
          account_number: account_number,
          routing_code:   routing_code
        }
      end

      private

      module ClientSupport
        def build_ach_beneficiary(attributes = {})
          Beneficiary::ACH.new(attributes)
        end
      end
    end
  end
end
