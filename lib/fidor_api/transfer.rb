module FidorApi

  module Transfer

    class Base < Resource

      def save
        raise InvalidRecordError unless valid?

        set_attributes self.class.request(:post, client.token.access_token, self.class.resource, {}, as_json)

        true
      end

      def self.all(access_token, options = {})
        Collection.build(self, request(:get, access_token, resource, options))
      end

      def self.find(access_token, id)
        new(request(:get, access_token, "/#{resource}/#{id}"))
      end

    end

    class Internal < Base
      extend ModelAttribute

      attribute :id,             :integer
      attribute :account_id,     :string
      attribute :user_id,        :string
      attribute :transaction_id, :string
      attribute :receiver,       :string
      attribute :external_uid,   :string
      attribute :amount,         :integer
      attribute :currency,       :string
      attribute :subject,        :string
      attribute :state,          :string
      attribute :created_at,     :time
      attribute :updated_at,     :time

      def self.required_attributes
        [ :account_id, :receiver, :external_uid, :amount, :subject ]
      end

      validates *required_attributes, presence: true

      private

      def self.resource
        "internal_transfers"
      end

      def as_json
        attributes.slice *self.class.required_attributes
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

    class SEPA < Base
      extend ModelAttribute

      attribute :id,             :integer
      attribute :account_id,     :string
      attribute :user_id,        :string
      attribute :transaction_id, :string
      attribute :remote_iban,    :string
      attribute :remote_bic,     :string
      attribute :remote_name,    :string
      attribute :amount,         :integer
      attribute :external_uid,   :string
      attribute :subject,        :string
      attribute :currency,       :string
      attribute :subject,        :string
      attribute :state,          :string
      attribute :created_at,     :time
      attribute :updated_at,     :time

      def self.required_attributes
        [ :account_id, :external_uid, :remote_iban, :remote_bic, :remote_name, :amount, :subject ]
      end

      validates *required_attributes, presence: true

      private

      def self.resource
        "sepa_credit_transfers"
      end

      def as_json
        attributes.slice *self.class.required_attributes
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

