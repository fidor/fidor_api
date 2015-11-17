module FidorApi

  class Resource
    include ActiveModel::Model

    attr_accessor :client

    def initialize(attributes = {})
      self.client = client
      set_attributes(attributes)
    end

    def self.request(method, access_token, endpoint, query_params = {}, body = {})
      response = connection.public_send(method, endpoint) do |request|
        request.params = query_params
        request.headers = {
          "Authorization" => "Bearer #{access_token}",
          "Accept"        => "application/vnd.fidor.de; version=1,text/json",
          "Content-Type"  => "application/json"
        }
        request.body = body.to_json unless body.empty?
      end
      JSON.parse response.body
    rescue Faraday::Error::ClientError => e
      if e.response[:status] == 401 && e.response[:body] =~ /token_not_found|Unauthorized token|expired/
        raise UnauthorizedTokenError
      else
        raise ClientError
      end
    end

    private

    def self.connection
      Faraday.new(url: FidorApi.configuration.api_url) do |config|
        config.use      Faraday::Request::BasicAuthentication, FidorApi.configuration.client_id, FidorApi.configuration.client_secret
        config.request  :url_encoded
        config.response :logger      if FidorApi.configuration.logging
        config.response :raise_error
        config.adapter  Faraday.default_adapter
      end
    end
  end

end
