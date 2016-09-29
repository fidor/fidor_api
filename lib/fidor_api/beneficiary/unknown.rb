module FidorApi
  module Beneficiary
    class Unknown < Base
      include Generic

      attribute :routing_type, :string
      attribute :routing_info, :json

      def set_attributes(attrs = {})
        self.routing_type = attrs["routing_type"]
        self.routing_info = attrs["routing_info"]
        super(attrs.except("routing_type", "routing_info"))
      end
    end
  end
end
