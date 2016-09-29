module FidorApi
  module Transfer
    class P2pAccountNumber < Base
      include Generic

      attribute :account_number, :string

      validates :account_number, presence: true, unless: :beneficiary_reference_passed?

      def set_attributes(attrs = {})
        set_beneficiary_attributes(attrs)
        self.account_number = attrs.fetch("beneficiary", {}).fetch("routing_info", {})["account_number"]
        super(attrs.except("beneficiary"))
      end

      def as_json_routing_type
        "FOS_P2P_ACCOUNT_NUMBER".freeze
      end

      def as_json_routing_info
        {
          account_number: account_number
        }
      end

      module ClientSupport
        def p2p_account_number_transfers(options = {})
          Transfer::P2pAccountNumber.all(options)
        end

        def p2p_account_number_transfer(id)
          Transfer::P2pAccountNumber.find(id)
        end

        def build_p2p_account_number_transfer(attributes = {})
          Transfer::P2pAccountNumber.new(attributes)
        end

        def update_p2p_account_number_transfer(id, attributes = {})
          Transfer::P2pAccountNumber.new(attributes.merge(id: id))
        end
      end
    end
  end
end
