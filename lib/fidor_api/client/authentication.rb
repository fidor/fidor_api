module FidorApi
  class Client
    module Authentication
      attr_accessor :token

      # oAuth2 - Resource Owner Password Grant Flow
      def login(username:, password:, grant_type: 'password')
        check_flow_support! :resource_owner_password_credentials

        self.token = oauth_token(
          grant_type: grant_type,
          username:   username,
          password:   password
        )
      end

      # oAuth2 - Client Credentials Flow
      def client_login
        check_flow_support! :client_credentials

        self.token = oauth_token(grant_type: 'client_credentials')
      end

      # oAuth2 - Authorization Code Grant Flow - Start
      def authorize_start(redirect_uri:, state: SecureRandom.hex(8))
        check_flow_support! :authorization_code

        "#{config.environment.auth_host}/oauth/authorize" \
          + "?client_id=#{config.client_id}" \
          + "&redirect_uri=#{CGI.escape(redirect_uri)}" \
          + "&state=#{state}" \
          + '&response_type=code'
      end

      # oAuth2 - Authorization Code Grant Flow - Complete
      def authorize_complete(redirect_uri:, code:)
        self.token = oauth_token(
          grant_type:   'authorization_code',
          client_id:    config.client_id,
          redirect_uri: redirect_uri,
          code:         code
        )
      end

      private

      def check_flow_support!(symbol)
        raise Errors::NotSupported \
          unless config.environment.auth_methods.include? symbol
      end

      def oauth_token(**body)
        response = connection(host: config.environment.auth_host).post(
          '/oauth/token',
          body: body,
          auth: [config.client_id, config.client_secret]
        )

        Token.new(response.body)
      end
    end
  end
end
