module FidorApi

  module TransactionDetails

    def self.build(type, hash)
      implementation(type).new(hash)
    end

    class Base
      def initialize(attributes = {})
        set_attributes(attributes)
      end

      def remote_display_name
        "Fidor Bank"
      end
    end

    class Transfer < Base
      extend ModelAttribute

      attribute :internal_transfer_id, :string
      attribute :sepa_credit_transfer_id, :string
      attribute :remote_account_id, :string
      attribute :remote_bic, :string
      attribute :remote_iban, :string
      attribute :remote_name, :string
      attribute :remote_nick, :string
      attribute :remote_subject, :string

      def remote_display_name
        remote_name.presence || remote_nick.presence || super
      end
    end

    class CreditCard < Base
      extend ModelAttribute

      attribute :cc_category, :string
      attribute :cc_merchant_category, :string
      attribute :cc_merchant_name, :string
      attribute :cc_sequence, :string
      attribute :cc_type, :string

      def remote_display_name
        cc_merchant_name.presence || super
      end
    end

    class Gmt < Base
      extend ModelAttribute

      attribute :destination_country, :string
      attribute :destination_currency, :string
      attribute :amount_in_destination_currency, :string
      attribute :exchange_rate, :string
      attribute :fee_transaction_id, :string
    end

    class Bonus < Base
      extend ModelAttribute

      attribute :affiliate_id, :string
      attribute :affiliate_name, :string
      attribute :affiliate_transaction_type_id, :string
      attribute :affiliate_transaction_type_name, :string
      attribute :affiliate_transaction_type_category, :string
    end

    class MobileTopup < Base
      extend ModelAttribute

      attribute :provider, :string
      attribute :phone_number, :string
      attribute :topup_subject, :string
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
        "fidor_payin"                     => Transfer,
        "fidor_payout"                    => Transfer,
        "emoney_payin"                    => Transfer,
        "sepa_payin"                      => Transfer,
        "payout"                          => Transfer,
        "creditcard_preauth"              => CreditCard,
        "creditcard_release"              => CreditCard,
        "creditcard_payout"               => CreditCard,
        "creditcard_payin"                => CreditCard,
        "creditcard_annual_fee"           => CreditCard,
        "creditcard_foreign_exchange_fee" => CreditCard,
        "creditcard_order_fee"            => CreditCard,
        "creditcard_order_cancellation"   => CreditCard,
        "creditcard_order_withdrawal_fee" => CreditCard,
        "creditcard_atm_fee"              => CreditCard,
        "creditcard_notification_fee"     => CreditCard,
        "sepa_core_direct_debit"          => Transfer,
        "sepa_b2b_direct_debit"           => Transfer,
        "gmt_payout"                      => Gmt,
        "gmt_refund"                      => Gmt,
        "gmt_fee"                         => Gmt,
        "bonus"                           => Bonus,
        "prepaid_mobile_topup"            => MobileTopup
      }.fetch(type, Unknown)
    end

  end

end
