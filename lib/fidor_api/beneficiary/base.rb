module FidorApi
  module Beneficiary
    class Base < Resource
      ROUTING_INFO_ERROR_PREFIX = "routing_info.".freeze

      def self.all(access_token, options = {})
        Collection.build(self, request(access_token: access_token, endpoint: "/#{resource}", query_params: options).body) do |hash|
          class_for_response_hash(hash)
        end
      end

      def self.find(access_token, id)
        hash  = request(access_token: access_token, endpoint: "/#{resource}/#{id}").body
        klass = class_for_response_hash(hash)
        klass.new(hash)
      end

      def self.delete(access_token, id)
        request(method: :delete, access_token: access_token, endpoint: "/#{resource}/#{id}")
        true
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

        super(attrs.except("contact", "bank", "routing_type", "routing_info"))
      end

      def as_json
        {
          account_id:  account_id,
          unique_name: unique_name,
          contact: {
            name:           contact_name,
            address_line_1: contact_address_line_1,
            address_line_2: contact_address_line_2,
            city:           contact_city,
            country:        contact_country
          }.compact,
          bank: {
            name:           bank_name,
            address_line_1: bank_address_line_1,
            address_line_2: bank_address_line_2,
            city:           bank_city,
            country:        bank_country
          }.compact,
          routing_type: as_json_routing_type,
          routing_info: as_json_routing_info
        }.compact
      end

      def map_errors(fields)
        fields.each do |hash|
          if respond_to? hash["field"].to_sym
            errors.add(hash["field"].to_sym, hash["message"])
          elsif hash["field"].start_with?(ROUTING_INFO_ERROR_PREFIX)
            invalid_field = hash["field"][ROUTING_INFO_ERROR_PREFIX.size..-1]
            errors.add(invalid_field, hash["key"].to_sym, message: hash["message"])
          end
        end
      end

      private

      def self.resource
        "beneficiaries"
      end

      def self.class_for_response_hash(hash)
        {
          "ACH"                    => FidorApi::Beneficiary::ACH,
          "FOS_P2P_ACCOUNT_NUMBER" => FidorApi::Beneficiary::P2pAccountNumber,
          "FOS_P2P_PHONE"          => FidorApi::Beneficiary::P2pPhone,
          "FOS_P2P_USERNAME"       => FidorApi::Beneficiary::P2pUsername
        }.fetch(hash["routing_type"], FidorApi::Beneficiary::Unknown)
      end
    end
  end
end
