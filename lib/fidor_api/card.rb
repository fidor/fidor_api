module FidorApi

  class Card < Resource
    extend ModelAttribute
    extend AmountAttributes

    attribute :id,                        :integer
    attribute :account_id,                :string
    attribute :inscription,               :string
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

    def self.all(access_token, options = {})
      Collection.build(self, request(access_token: access_token, endpoint: "/cards", query_params: options))
    end

    def self.find(access_token, id)
      new(request(access_token: access_token, endpoint: "/cards/#{id}"))
    end

    module ClientSupport
      def cards(options = {})
        Card.all(token.access_token, options)
      end

      def card(id)
        Card.find(token.access_token, id)
      end
    end
  end

end
