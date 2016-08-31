module FidorApi
  module Beneficiary
    class P2pUsername < Base
      include Generic

      attribute :username, :string

      def initialize(attrs = {})
        self.username = attrs.fetch("routing_info", {})["username"]
        super(attrs.except("routing_type", "routing_info"))
      end
    end
  end
end
