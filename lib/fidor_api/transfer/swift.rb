module FidorApi
  module Transfer
    class Swift < Base
      include Generic

      validates :contact_name, presence: true, unless: :beneficiary_reference_passed?

      attribute :account_number,   :string
      attribute :swift_code,       :string
      attribute :account_currency, :string

      validates :account_number,   presence: true, unless: :beneficiary_reference_passed?
      validates :swift_code,       presence: true, unless: :beneficiary_reference_passed?
      validates :account_currency, presence: true, unless: :beneficiary_reference_passed?

      def set_attributes(attrs = {})
        set_beneficiary_attributes(attrs)
        self.account_number   = attrs.fetch("beneficiary", {}).fetch("routing_info", {})["account_number"]
        self.swift_code       = attrs.fetch("beneficiary", {}).fetch("routing_info", {})["swift_code"]
        self.account_currency = attrs.fetch("beneficiary", {}).fetch("routing_info", {})["account_currency"]
        super(attrs.except("beneficiary"))
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

      private

      def remote_create
        response = endpoint.for(self).post(payload: self.as_json)

        if path = response.headers["X-Fidor-Confirmation-Path"]
          self.confirmable_action = ConfirmableAction.new(id: path.split("/").last)
        end

        response
      end
    end
  end
end
