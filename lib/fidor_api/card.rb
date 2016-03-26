module FidorApi

  class Card < Resource
    extend ModelAttribute
    extend AmountAttributes

    attribute :id,                        :integer
    attribute :account_id,                :string
    attribute :inscription,               :string
    attribute :pin,                       :string
    attribute :type,                      :string
    attribute :design,                    :string
    attribute :currency,                  :string
    attribute :physical,                  :boolean
    attribute :email_notification,        :boolean
    attribute :sms_notification,          :boolean
    attribute :payed,                     :boolean
    attribute :state,                     :string
    attribute :lock_reason,               :string
    attribute :disabled,                  :boolean
    attribute :created_at,                :time
    attribute :updated_at,                :time

    amount_attribute :balance
    amount_attribute :atm_limit
    amount_attribute :transaction_single_limit
    amount_attribute :transaction_volume_limit

    def self.required_attributes
      [ :account_id, :type, :design, :currency, :pin ]
    end

    validates *required_attributes, presence: true

    def self.all(access_token, options = {})
      Collection.build(self, request(access_token: access_token, endpoint: "/cards", query_params: options))
    end

    def self.find(access_token, id)
      new(request(access_token: access_token, endpoint: "/cards/#{id}"))
    end

    def self.lock(access_token, id)
      request(method: :put, access_token: access_token, endpoint: "/cards/#{id}/lock")
      true
    end

    def self.unlock(access_token, id)
      request(method: :put, access_token: access_token, endpoint: "/cards/#{id}/unlock")
      true
    end

    def save
      raise InvalidRecordError unless valid?

      set_attributes self.class.request(method: :post, access_token: client.token.access_token, endpoint: "/cards", body: as_json)

      true
    end

    def as_json
      attributes.slice *self.class.required_attributes
    end

    module ClientSupport
      def cards(options = {})
        Card.all(token.access_token, options)
      end

      def card(id)
        Card.find(token.access_token, id)
      end

      def lock_card(id)
        Card.lock(token.access_token, id)
      end

      def unlock_card(id)
        Card.unlock(token.access_token, id)
      end

      def build_card(attributes = {})
        Card.new(attributes.merge(client: self))
      end
    end
  end

end
