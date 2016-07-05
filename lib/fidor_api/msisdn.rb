module FidorApi

  module Msisdn
    extend self

    def check(msisdn)
      post "/msisdn/check", {
        msisdn:        msisdn,
        os_type:       FidorApi.configuration.os_type,
        affiliate_uid: FidorApi.configuration.affiliate_uid
      }
    end

    def verify(msisdn, code)
      post "/msisdn/verify", {
        msisdn: msisdn,
        code:   code
      }
    end

    private

    def connection
      Faraday.new(url: FidorApi.configuration.oauth_url, ssl: { verify: FidorApi.configuration.verify_ssl }) do |config|
        config.use      Faraday::Request::BasicAuthentication, FidorApi.configuration.htauth_user, FidorApi.configuration.htauth_password
        config.request  :url_encoded
        config.response :logger if FidorApi.configuration.logging
        config.response :raise_error
        config.adapter  Faraday.default_adapter
      end
    end

    def post(endpoint, body)
      response = connection.post endpoint do |request|
        request.headers = {
          "Accept"       => "application/vnd.fidor.de; version=1,text/json",
          "Content-Type" => "application/json"
        }
        request.body = body.to_json
      end
      response.body
    end
  end

end
