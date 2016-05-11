module FidorApi

  module Transfer

    class Base < Resource

      def save
        raise InvalidRecordError unless valid?
        set_attributes self.class.request(method: :post, access_token: client.token.access_token, endpoint: self.class.resource, body: as_json).body
        true
      rescue ValidationError => e
        map_errors(e.fields)
        false
      end

      def self.all(access_token, options = {})
        Collection.build(self, request(access_token: access_token, endpoint: resource, query_params: options).body)
      end

      def self.find(access_token, id)
        new(request(access_token: access_token, endpoint: "/#{resource}/#{id}").body)
      end

    end

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

    class FPS < Base
      extend ModelAttribute
      extend AmountAttributes

      attribute :id,               :integer
      attribute :account_id,       :string
      attribute :user_id,          :string
      attribute :transaction_id,   :string
      attribute :remote_account,   :string
      attribute :remote_sort_code, :string
      attribute :remote_name,      :string
      attribute :external_uid,     :string
      attribute :subject,          :string
      attribute :currency,         :string
      attribute :subject,          :string
      attribute :state,            :string
      attribute :created_at,       :time
      attribute :updated_at,       :time
      amount_attribute :amount

      def self.required_attributes
        [ :account_id, :external_uid, :remote_account, :remote_sort_code, :remote_name, :amount, :subject ]
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
        "fps_transfers"
      end

      module ClientSupport
        def fps_transfers(options = {})
          Transfer::FPS.all(token.access_token, options)
        end

        def fps_transfer(id)
          Transfer::FPS.find(token.access_token, id)
        end

        def build_fps_transfer(attributes = {})
          Transfer::FPS.new(attributes.merge(client: self))
        end
      end
    end

  end

end

