module FidorApi

  module Auth
    extend self

    def authorize_url
      fidor_authorize_url
    end

    def fetch_token(code)
      response = connection.post "/oauth/token", {
        client_id:    FidorApi.configuration.client_id,
        redirect_uri: FidorApi.configuration.callback_url,
        code:         code,
        grant_type:   "authorization_code"
      }
      Token.new JSON.parse(response.body)
    end

    def refresh_token(token)
      response = connection.post "/oauth/token", {
        grant_type:    "refresh_token",
        refresh_token: token.refresh_token
      }
      Token.new JSON.parse(response.body)
    end

    private

    def connection
      Faraday.new(url: FidorApi.configuration.oauth_url, ssl: { verify: FidorApi.configuration.verify_ssl }) do |config|
        config.use      Faraday::Request::BasicAuthentication, FidorApi.configuration.client_id, FidorApi.configuration.client_secret
        config.request  :url_encoded
        config.response :logger if FidorApi.configuration.logging
        config.response :raise_error
        config.adapter  Faraday.default_adapter
      end
    end

    def fidor_authorize_url(state = "empty")
      "#{FidorApi.configuration.oauth_url}/oauth/authorize?client_id=#{FidorApi.configuration.client_id}&redirect_uri=#{CGI::escape FidorApi.configuration.callback_url}&state=#{state}&response_type=code"
    end
  end

end
