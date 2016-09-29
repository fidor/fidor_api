module FidorApi
  module Beneficiary
    class P2pPhone < Base
      include Generic

      attribute :mobile_phone_number, :string

      def set_attributes(attrs = {})
        self.mobile_phone_number = attrs.fetch("routing_info", {})["mobile_phone_number"]
        super(attrs.except("routing_type", "routing_info"))
      end
    end
  end
end
