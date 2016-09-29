module FidorApi
  module Beneficiary
    class P2pAccountNumber < Base
      include Generic

      attribute :account_number, :string

      def set_attributes(attrs = {})
        self.account_number = attrs.fetch("routing_info", {})["account_number"]
        super(attrs.except("routing_type", "routing_info"))
      end
    end
  end
end
