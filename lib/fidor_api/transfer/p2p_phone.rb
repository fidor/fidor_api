module FidorApi
  module Transfer
    class P2pPhone < Base
      include Generic

      attribute :mobile_phone_number, :string

      validates :mobile_phone_number, presence: true, unless: :beneficiary_reference_passed?

      def initialize(attrs = {})
        set_beneficiary_attributes(attrs)
        self.mobile_phone_number = attrs.fetch("beneficiary", {}).fetch("routing_info", {})["mobile_phone_number"]
        super(attrs.except("beneficiary"))
      end

      def as_json_routing_type
        "FOS_P2P_PHONE"
      end

      def as_json_routing_info
        {
          mobile_phone_number: mobile_phone_number
        }
      end

      module ClientSupport
        def p2p_phone_transfers(options = {})
          Transfer::P2pPhone.all(token.access_token, options)
        end

        def p2p_phone_transfer(id)
          Transfer::P2pPhone.find(token.access_token, id)
        end

        def build_p2p_phone_transfer(attributes = {})
          Transfer::P2pPhone.new(attributes.merge(client: self))
        end

        def update_p2p_phone_transfer(id, attributes = {})
          Transfer::P2pPhone.new(attributes.merge(client: self, id: id))
        end
      end
    end
  end
end
