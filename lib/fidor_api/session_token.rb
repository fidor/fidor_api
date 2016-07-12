module FidorApi

  class SessionToken < Resource
    extend ModelAttribute
    extend AmountAttributes

    attribute :token, :string

    def self.create(access_token)
      new request(
        method:       :post,
        access_token: access_token,
        endpoint:     "/session_tokens",
      ).body
    end

    module ClientSupport
      def create_session_token
        SessionToken.create(token.access_token)
      end
    end
  end

end
