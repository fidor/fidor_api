module FidorApi
  module Transfer
    class ACH < Base
      include Generic

      attribute :account_number, :string
      attribute :routing_code,   :string

      validates :account_number, presence: true, unless: :beneficiary_reference_passed?
      validates :routing_code,   presence: true, unless: :beneficiary_reference_passed?

      def initialize(attrs = {})
        set_beneficiary_attributes(attrs)
        self.account_number = attrs.fetch("beneficiary", {}).fetch("routing_info", {})["account_number"]
        self.routing_code   = attrs.fetch("beneficiary", {}).fetch("routing_info", {})["routing_code"]
        super(attrs.except("beneficiary"))
      end

      def as_json_routing_type
        "ACH"
      end

      def as_json_routing_info
        {
          account_number: account_number,
          routing_code: routing_code
        }
      end

      module ClientSupport
        def ach_transfers(options = {})
          Transfer::ACH.all(token.access_token, options)
        end

        def ach_transfer(id)
          Transfer::ACH.find(token.access_token, id)
        end

        def build_ach_transfer(attributes = {})
          Transfer::ACH.new(attributes.merge(client: self))
        end
      end
    end
  end
end
