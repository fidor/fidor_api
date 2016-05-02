module FidorApi

  module Transfer

    class Base < Resource

      def save
        if id.nil?
          create
        else
          raise NoUpdatesAllowedError
        end
      end

      def self.all(access_token, options = {})
        Collection.build(self, request(access_token: access_token, endpoint: resource, query_params: options).body)
      end

      def self.find(access_token, id)
        new(request(access_token: access_token, endpoint: "/#{resource}/#{id}").body)
      end

    end

    class ACH < Base
      extend ModelAttribute
      extend AmountAttributes

      attribute :id,             :string
      attribute :account_id,     :string
      attribute :external_uid,   :string
      attribute :contact_name,   :string
      attribute :account_number, :string
      attribute :routing_code,   :string
      attribute :subject,        :string
      attribute :currency,       :string
      attribute :subject,        :string
      attribute :state,          :string
      attribute :created_at,     :time
      attribute :updated_at,     :time
      amount_attribute :amount

      def self.required_attributes
        [ :account_id, :external_uid, :contact_name, :account_number, :routing_code, :amount, :subject, :currency ]
      end

      validates *required_attributes, presence: true

      def initialize(attrs = {})
        self.contact_name   = attrs.fetch("beneficiary", {}).fetch("contact", {})["name"]
        self.account_number = attrs.fetch("beneficiary", {}).fetch("routing_info", {})["account_number"]
        self.routing_code   = attrs.fetch("beneficiary", {}).fetch("routing_info", {})["routing_code"]
        super(attrs.except("beneficiary"))
      end

      def as_json
        {
          account_id: account_id,
          external_uid: external_uid,
          amount: (amount * 100).to_i,
          currency: currency,
          subject: subject,
          beneficiary: {
            contact: {
              name: contact_name
            },
            routing_type: "ACH",
            routing_info: {
              account_number: account_number,
              routing_code: routing_code
            }
          }
        }
      end

      private

      def contact
        (beneficiary || {}).fetch("contact", {})
      end

      def routing_info
        (beneficiary || {}).fetch("routing_info", {})
      end

      def self.resource
        "transfers"
      end

      def map_errors(fields)
        fields.each do |hash|
          if respond_to? hash["field"].to_sym
            errors.add(hash["field"].to_sym, hash["message"])
          elsif hash["field"] == "beneficiary" && invalid_fields = hash["message"][/Invalid fields in routing_info: (.*)/, 1]
            invalid_fields.split(",").each do |invalid_field|
              errors.add(invalid_field, :invalid)
            end
          end
        end
      end

      module ClientSupport
        def ach_transfers(options = {})
          Transfer::ACH.all(token.access_token, options)
        end

        def ach_transfer(id)
          Transfer::ACH.find(token.access_token, id)
        end

        def build_ach_transfer(attributes = {})
          Transfer::ACH.new(attributes.merge(client: self))
        end
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

