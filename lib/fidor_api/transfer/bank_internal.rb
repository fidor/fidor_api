module FidorApi
  module Transfer
    class BankInternal < Base
      include Generic
      attribute :account_number, :string

      validates :account_number, presence: true, unless: :beneficiary_reference_passed?

      def set_attributes(attrs = {})
        self.account_number = attrs.fetch("beneficiary", {}).fetch("routing_info", {})["account_number"]
        super(attrs)
      end

      def as_json_routing_type
        'BANK_INTERNAL'
      end

      def as_json_routing_info
        {
          account_number: account_number
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
