module FidorApi
  class Card < Resource
    extend ModelAttribute
    extend AmountAttributes
    include CardLimitAttribute

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
    attribute :valid_until,               :time
    attribute :lock_reason,               :string
    attribute :disabled,                  :boolean
    attribute :address,                   :json
    attribute :created_at,                :time
    attribute :updated_at,                :time

    amount_attribute :balance

    def self.required_attributes
      %i(account_id type)
    end

    def self.writeable_attributes
      required_attributes + %i(pin address)
    end

    validates(*required_attributes, presence: true)

    def self.all(access_token, options = {})
      Collection.build(self, request(access_token: access_token, endpoint: "/cards", query_params: options).body)
    end

    def self.find(access_token, id)
      new(request(access_token: access_token, endpoint: "/cards/#{id}").body)
    end

    def self.activate(access_token, id)
      request(method: :put, access_token: access_token, endpoint: "/cards/#{id}/activate")
      true
    end

    def self.lock(access_token, id)
      request(method: :put, access_token: access_token, endpoint: "/cards/#{id}/lock")
      true
    end

    def self.unlock(access_token, id)
      request(method: :put, access_token: access_token, endpoint: "/cards/#{id}/unlock")
      true
    end

    def self.cancel(access_token, id)
      request(method: :put, access_token: access_token, endpoint: "/cards/#{id}/cancel")
      true
    end

    def save
      if id.nil?
        create
      else
        raise NoUpdatesAllowedError
      end
    end

    def as_json
      attributes.slice(*self.class.writeable_attributes)
    end

    # comfort shorthands for easier validations
    %w(name line_1 line_2 city postal_code country).each do |field|
      define_method("address_#{field}") { address.try :[], field }
      define_method("address_#{field}=") { |val| self.address ||= {}; address[field] = val }
    end

    private

    def self.resource
      "cards"
    end

    module ClientSupport
      def cards(options = {})
        Card.all(token.access_token, options)
      end

      def card(id)
        Card.find(token.access_token, id)
      end

      def activate_card(id)
        Card.activate(token.access_token, id)
      end

      def lock_card(id)
        Card.lock(token.access_token, id)
      end

      def unlock_card(id)
        Card.unlock(token.access_token, id)
      end

      def cancel_card(id)
        Card.cancel(token.access_token, id)
      end

      def build_card(attributes = {})
        Card.new(attributes.merge(client: self))
      end
    end
  end

end
