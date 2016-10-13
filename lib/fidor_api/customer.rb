module FidorApi
  class Customer < Connectivity::Resource
    extend ModelAttribute

    self.endpoint = Connectivity::Endpoint.new('/customers', :collection)

    module Gender
      extend self

      class Base
        include Singleton
      end

      class Male    < Base; end
      class Female  < Base; end
      class Unknonw < Base; end

      MAPPING = {
        Male   => "m",
        Female => "f"
      }

      def for_api_value(api_value)
        MAPPING.key(api_value) || Unknonw
      end

      def object_to_string(object)
        MAPPING[object]
      end
    end

    attribute :id,                        :integer
    attribute :email,                     :string
    attribute :first_name,                :string
    attribute :last_name,                 :string
    attribute :gender,                    :string
    attribute :title,                     :string
    attribute :nick,                      :string
    attribute :maiden_name,               :string
    attribute :adr_street,                :string
    attribute :adr_street_number,         :string
    attribute :adr_post_code,             :string
    attribute :adr_city,                  :string
    attribute :adr_country,               :string
    attribute :adr_phone,                 :string
    attribute :adr_mobile,                :string
    attribute :adr_fax,                   :string
    attribute :adr_businessphone,         :string
    attribute :birthday,                  :time
    attribute :is_verified,               :boolean
    attribute :nationality,               :string
    attribute :marital_status,            :integer
    attribute :religion,                  :integer
    attribute :id_card_registration_city, :string
    attribute :id_card_number,            :string
    attribute :id_card_valid_until,       :time
    attribute :created_at,                :time
    attribute :updated_at,                :time
    attribute :creditor_identifier,       :string
    attribute :affiliate_uid,             :string
    attribute :verification_token,        :string
    attribute :password,                  :string
    attribute :tos,                       :boolean
    attribute :privacy_policy,            :boolean
    attribute :own_interest,              :boolean
    attribute :us_citizen,                :boolean
    attribute :us_tax_payer,              :boolean
    attribute :preferred_language,        :string
    attribute :community_user_picture,    :string
    attribute :country_of_birth,          :string
    attribute :additional_first_name,     :string

    def self.first
      all(page: 1, per_page: 1).first
    end

    def initialize(*args)
      super
      self.affiliate_uid = FidorApi.configuration.affiliate_uid
    end

    def gender
      Gender.for_api_value(@gender)
    end

    def gender=(value)
      @gender = if value.class == Class && value.instance.is_a?(FidorApi::Customer::Gender::Base)
        Gender.object_to_string(value)
      else
        value
      end
    end

    def as_json(options = nil)
      attributes.tap { |a| a[:birthday] = a[:birthday].try(:to_date) }
    end

    private

    def remote_create
      endpoint.for(self).post(payload: self.as_json, tokenless: true)
    end

    def remote_update
      raise NoUpdatesAllowedError
    end

    module ClientSupport
      def customers(options = {})
        Customer.all(options)
      end

      def first_customer
        Customer.first
      end

      def update_customer(id, attributes)
        Customer.endpoint.for(id).put(payload: attributes)
      end
    end
  end
end
