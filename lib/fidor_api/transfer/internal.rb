module FidorApi
  module Transfer
    class Internal < Base
      extend ModelAttribute
      extend AmountAttributes

      attribute :id,             :integer
      attribute :account_id,     :string
      attribute :user_id,        :string
      attribute :transaction_id, :string
      attribute :receiver,       :string
      attribute :external_uid,   :string
      attribute :currency,       :string
      attribute :subject,        :string
      attribute :state,          :string
      attribute :created_at,     :time
      attribute :updated_at,     :time
      amount_attribute :amount

      def self.required_attributes
        [ :account_id, :receiver, :external_uid, :amount, :subject ]
      end

      def self.writeable_attributes
        required_attributes
      end

      validates *required_attributes, presence: true

      def as_json
        attributes.slice *self.class.writeable_attributes
      end

      private

      def self.resource
        "internal_transfers"
      end

      module ClientSupport
        def internal_transfers(options = {})
          Transfer::Internal.all(token.access_token, options)
        end

        def internal_transfer(id)
          Transfer::Internal.find(token.access_token, id)
        end

        def build_internal_transfer(attributes = {})
          Transfer::Internal.new(attributes.merge(client: self))
        end
      end
    end
  end
end
