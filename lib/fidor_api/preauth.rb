module FidorApi
  class Preauth < Connectivity::Resource
    extend ModelAttribute
    extend AmountAttributes

    self.endpoint = Connectivity::Endpoint.new('/preauths', :collection)

    attribute :id,                   :integer
    attribute :account_id,           :string
    attribute :preauth_type,         :string
    attribute :preauth_type_details, :json
    attribute :expires_at,           :time
    attribute :created_at,           :time
    attribute :updated_at,           :time
    attribute :currency,             :string
    amount_attribute :amount

    def preauth_type_details
      @_preauth_type_details ||= PreauthDetails.build(@preauth_type, @preauth_type_details)
    end

    module ClientSupport
      def preauths(options = {})
        Preauth.all(options)
      end

      def preauth(id)
        Preauth.find(id)
      end
    end
  end

end
