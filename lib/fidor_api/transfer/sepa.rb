module FidorApi
  module Transfer
    class SEPA < Base
      extend ModelAttribute
      extend AmountAttributes

      attribute :id,             :integer
      attribute :account_id,     :string
      attribute :user_id,        :string
      attribute :transaction_id, :string
      attribute :remote_iban,    :string
      attribute :remote_bic,     :string
      attribute :remote_name,    :string
      attribute :external_uid,   :string
      attribute :subject,        :string
      attribute :currency,       :string
      attribute :subject,        :string
      attribute :state,          :string
      attribute :created_at,     :time
      attribute :updated_at,     :time
      amount_attribute :amount

      def self.required_attributes
        [ :account_id, :external_uid, :remote_iban, :remote_name, :amount, :subject ]
      end

      def self.writeable_attributes
        required_attributes + [:remote_bic]
      end

      validates *required_attributes, presence: true

      def as_json
        attributes.slice *self.class.writeable_attributes
      end

      private

      def self.resource
        "sepa_credit_transfers"
      end

      module ClientSupport
        def sepa_transfers(options = {})
          Transfer::SEPA.all(token.access_token, options)
        end

        def sepa_transfer(id)
          Transfer::SEPA.find(token.access_token, id)
        end

        def build_sepa_transfer(attributes = {})
          Transfer::SEPA.new(attributes.merge(client: self))
        end
      end
    end
  end
end
