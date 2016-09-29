module FidorApi
  class SessionToken < Connectivity::Resource
    extend ModelAttribute
    extend AmountAttributes

    attribute :token, :string

    self.endpoint = Connectivity::Endpoint.new('/session_tokens', :collection)

    def self.create(access_token)
      new endpoint.for(self).post(payload: {access_token: access_token}).body
    end

    module ClientSupport
      def create_session_token
        SessionToken.create(token.access_token)
      end
    end
  end
end
