module FidorApi
  class Card < Connectivity::Resource
    extend ModelAttribute
    extend AmountAttributes
    include CardLimitAttribute

    self.endpoint = Connectivity::Endpoint.new('/cards', :collection)

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

    def activate
      endpoint.for(self).put(action: 'activate')
      true
    end

    def lock
      endpoint.for(self).put(action: 'lock')
      true
    end

    def unlock
      endpoint.for(self).put(action: 'unlock')
      true
    end

    def cancel(reason: 'lost')
      case reason
      when 'lost'
        endpoint.for(self).put(action: 'cancel')
      when 'stolen'
        endpoint.for(self).put(action: 'block')
      else
        fail ArgumentError, "Unknown reason: #{reason.inspect}"
      end
      true
    end

    def as_json
      attributes.slice(*self.class.writeable_attributes)
    end

    # comfort shorthands for easier validations
    %w(name line_1 line_2 city postal_code country).each do |field|
      define_method("address_#{field}") { address.try :[], field }
      define_method("address_#{field}=") { |val| self.address ||= {}; address[field] = val }
    end
  end
end
