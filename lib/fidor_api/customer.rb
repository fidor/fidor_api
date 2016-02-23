module FidorApi

  class Customer < Resource
    extend ModelAttribute

    module Gender
      extend self

      class Base
        include Singleton
      end

      class Male    < Base; end
      class Female  < Base; end
      class Unknonw < Base; end

      def for_api_value(api_value)
        case api_value
        when "m"
          Male
        when "f"
          Female
        else
          Unknonw
        end
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

    def self.all(access_token, options = {})
      Collection.build(self, request(:get, access_token, "/customers", options))
    end

    def self.first(access_token)
      all(access_token, page: 1, per_page: 1).first
    end

    def gender
      Gender.for_api_value(@gender)
    end

    def save
      raise InvalidRecordError unless valid?
      raise NoUpdatesAllowedError if id.present?

      set_attributes self.class.request(:post, nil, "customers", {}, as_json)

      true
    end

    module ClientSupport
      def customers(options = {})
        Customer.all(token.access_token, options)
      end

      def first_customer
        Customer.first(token.access_token)
      end
    end
  end

end
