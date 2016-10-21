module FidorApi
  module Beneficiary
    class Base < Connectivity::Resource
      ROUTING_INFO_ERROR_PREFIX = "routing_info.".freeze

      self.endpoint = Connectivity::Endpoint.new('/beneficiaries', :collection)

      attr_accessor :confirmable_action

      class << self
        def new(hash={})
          if self == Base
            class_for_response_hash(hash).new hash
          else
            super
          end
        end

        def delete(id)
          endpoint.for(new(id: id)).delete
          true
        end

        private

        def class_for_response_hash(hash)
          {
            "FOS_P2P_ACCOUNT_NUMBER" => FidorApi::Beneficiary::P2pAccountNumber,
            "FOS_P2P_PHONE"          => FidorApi::Beneficiary::P2pPhone,
            "FOS_P2P_USERNAME"       => FidorApi::Beneficiary::P2pUsername,
            "UAE_DOMESTIC"           => FidorApi::Beneficiary::UaeDomestic
          }.fetch(hash["routing_type"], FidorApi::Beneficiary::Unknown)
        end
      end

      def set_attributes(attrs = {})
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

      def save
        fail InvalidRecordError unless valid?
        super
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

      private

      def remote_create
        response = super
        if path = response.headers["X-Fidor-Confirmation-Path"]
          self.confirmable_action = ConfirmableAction.new(id: path.split("/").last)
        end
        response
      end

      def remote_update(*attributes)
        response = super
        if path = response.headers["X-Fidor-Confirmation-Path"]
          self.confirmable_action = ConfirmableAction.new(id: path.split("/").last)
        end
        response
      end

      def map_errors(fields)
        fields.each do |hash|
          field = hash["field"].to_sym
          key   = hash["key"].try :to_sym

          if field == :base || respond_to?(field)
            if key
              errors.add(field, key, message: hash["message"])
            else
              errors.add(field, hash["message"])
            end
          elsif hash["field"].start_with?(ROUTING_INFO_ERROR_PREFIX)
            invalid_field = hash["field"][ROUTING_INFO_ERROR_PREFIX.size..-1]
            errors.add(invalid_field, hash["key"].to_sym, message: hash["message"])
          end
        end
      end
    end
  end
end
