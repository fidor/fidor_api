module FidorApi

  class Preauth < Resource
    extend ModelAttribute
    extend AmountAttributes

    attribute :id,                   :integer
    attribute :account_id,           :string
    attribute :preauth_type,         :string
    attribute :preauth_type_details, :json
    attribute :expires_at,           :time
    attribute :created_at,           :time
    attribute :updated_at,           :time
    attribute :currency,             :string
    amount_attribute :amount

    def self.all(access_token, options = {})
      Collection.build(self, request(access_token: access_token, endpoint: "/preauths", query_params: options))
    end

    def self.find(access_token, id)
      new(request(access_token: access_token, endpoint: "/preauths/#{id}"))
    end

    def preauth_type_details
      @_preauth_type_details ||= PreauthDetails.build(@preauth_type, @preauth_type_details)
    end

    module ClientSupport
      def preauths(options = {})
        Preauth.all(token.access_token, options)
      end

      def preauth(id)
        Preauth.find(token.access_token, id)
      end
    end
  end

end
