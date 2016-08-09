module FidorApi

  class Beneficiary < Resource
    extend ModelAttribute
    extend AmountAttributes

    attribute :id,                     :string
    attribute :account_id,             :string
    attribute :contact_name,           :string
    attribute :contact_address_line_1, :string
    attribute :contact_address_line_2, :string
    attribute :contact_city,           :string
    attribute :contact_country,        :string
    attribute :bank_name,              :string
    attribute :bank_address_line_1,    :string
    attribute :bank_address_line_2,    :string
    attribute :bank_city,              :string
    attribute :bank_country,           :string
    attribute :routing_type,           :string
    attribute :routing_info,           :json
    attribute :verified,               :boolean

    def self.all(access_token, options = {})
      Collection.build(self, request(access_token: access_token, endpoint: "/#{resource}", query_params: options).body)
    end

    def self.find(access_token, id)
      new(request(access_token: access_token, endpoint: "/#{resource}/#{id}").body)
    end

    def self.resource
      "beneficiaries"
    end

    def initialize(attrs = {})
      self.contact_name           = attrs.fetch("contact", {})["name"]
      self.contact_address_line_1 = attrs.fetch("contact", {})["address_line_1"]
      self.contact_address_line_2 = attrs.fetch("contact", {})["address_line_2"]
      self.contact_city           = attrs.fetch("contact", {})["city"]
      self.contact_country        = attrs.fetch("contact", {})["country"]

      self.bank_name              = attrs.fetch("bank",    {})["name"]
      self.bank_address_line_1    = attrs.fetch("bank",    {})["address_line_1"]
      self.bank_address_line_2    = attrs.fetch("bank",    {})["address_line_2"]
      self.bank_city              = attrs.fetch("bank",    {})["city"]
      self.bank_country           = attrs.fetch("bank",    {})["country"]

      super(attrs.except("contact", "bank"))
    end

    module ClientSupport
      def beneficiaries(options = {})
        Beneficiary.all(token.access_token, options)
      end

      def beneficiary(id)
        Beneficiary.find(token.access_token, id)
      end
    end
  end

end
