module FidorApi

  module PreauthDetails

    def self.build(type, hash)
      implementation(type).new(hash)
    end

    class Base
      def initialize(attributes = {})
        set_attributes(attributes)
      end

      def description
        "-"
      end
    end

    class CreditCard < Base
      extend ModelAttribute

      attribute :cc_category, :string
      attribute :cc_merchant_category, :string
      attribute :cc_merchant_name, :string
      attribute :cc_sequence, :string
      attribute :cc_type, :string
      attribute :pos_code, :string
      attribute :financial_network_code, :string

      def description
        cc_merchant_name.presence || super
      end
    end

    class InternalTransfer < Base
      extend ModelAttribute

      attribute :internal_transfer_id, :string
      attribute :remote_account_id, :string
      attribute :remote_bic, :string
      attribute :remote_iban, :string
      attribute :remote_name, :string
      attribute :remote_nick, :string
      attribute :remote_subject, :string

      def description
        remote_name || remote_nick || super
      end
    end

    class CapitalBond < Base
      extend ModelAttribute
    end

    class CurrencyOrder < Base
      extend ModelAttribute
    end

    class Gmt < Base
      extend ModelAttribute

      attribute :destination_country, :string
      attribute :destination_currency, :string
      attribute :amount_in_destination_currency, :string
      attribute :exchange_rate, :string
      attribute :fee_transaction_id, :string
    end

    class Ripple < Base
      extend ModelAttribute
    end

    class Unknown < Base
      extend ModelAttribute

      def method_missing(method, *args)
        return if method[-1] == "="
        super
      end
    end

    private

    def self.implementation(type)
      {
        "creditcard_preauth"        => CreditCard,
        "internal_transfer_preauth" => InternalTransfer,
        "capital_bond_preauth"      => CapitalBond,
        "currency_order_preauth"    => CurrencyOrder,
        "gmt_preauth"               => Gmt,
        "ripple_preauth"            => Ripple
      }.fetch(type, Unknown)
    end

  end

end
