module FidorApi
  module Beneficiary
    module Generic
      def self.included(base)
        base.extend ModelAttribute

        base.attribute :id,                     :string
        base.attribute :account_id,             :string
        base.attribute :unique_name,            :string
        base.attribute :contact_name,           :string
        base.attribute :contact_address_line_1, :string
        base.attribute :contact_address_line_2, :string
        base.attribute :contact_city,           :string
        base.attribute :contact_country,        :string
        base.attribute :bank_name,              :string
        base.attribute :bank_address_line_1,    :string
        base.attribute :bank_address_line_2,    :string
        base.attribute :bank_city,              :string
        base.attribute :bank_country,           :string
        base.attribute :verified,               :boolean
      end
    end
  end
end
