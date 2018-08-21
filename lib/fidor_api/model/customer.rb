module FidorApi
  module Model
    class Customer < Base
      attribute :id,                        :integer
      attribute :email,                     :string
      attribute :first_name,                :string
      attribute :last_name,                 :string
      attribute :additional_first_name,     :string
      attribute :gender,                    :string
      attribute :title,                     :string
      attribute :nick,                      :string
      attribute :maiden_name,               :string
      attribute :adr_street,                :string
      attribute :adr_street_number,         :string
      attribute :adr_post_code,             :string
      attribute :adr_city,                  :string
      attribute :birthplace,                :string
      attribute :country_of_birth,          :string
      attribute :adr_country,               :string
      attribute :adr_phone,                 :string
      attribute :adr_mobile,                :string
      attribute :adr_fax,                   :string
      attribute :adr_businessphone,         :string
      attribute :birthday,                  :string
      attribute :is_verified,               :string
      attribute :nationality,               :string
      attribute :marital_status,            :string
      attribute :occupation,                :string
      attribute :religion,                  :string
      attribute :id_card_registration_city, :string
      attribute :id_card_number,            :string
      attribute :id_card_valid_until,       :string
      attribute :preferred_language,        :string
    end
  end
end
