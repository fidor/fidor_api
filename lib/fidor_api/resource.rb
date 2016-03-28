module FidorApi

  class Resource
    include ActiveModel::Model

    attr_accessor :client

    def initialize(attributes = {})
      set_attributes(attributes)
    end

    def self.request(method: :get, access_token: nil, endpoint: nil, query_params: {}, body: {}, htauth: false)
      response = connection(htauth: htauth).public_send(method, endpoint) do |request|
        request.params = query_params
        request.headers = {}
        request.headers["Authorization"] = "Bearer #{access_token}" if access_token
        request.headers["Accept"]        = "application/vnd.fidor.de; version=1,text/json"
        request.headers["Content-Type"]  = "application/json"
        request.body = body.to_json unless body.empty?
      end
      if response.headers["content-type"] =~ /json/
        JSON.parse(response.body)
      else
        response.body
      end
    rescue Faraday::Error::ClientError => e
      if e.response[:status] == 401 && e.response[:body] =~ /token_not_found|Unauthorized token|expired/
        raise UnauthorizedTokenError
      else
        raise ClientError
      end
    end

    def self.model_name
      ActiveModel::Name.new(self, nil, self.name.sub("FidorApi::", ""))
    end

    def persisted?
      id.present?
    end

    private

    def self.connection(htauth: false)
      Faraday.new(url: FidorApi.configuration.api_url) do |config|
        config.use      Faraday::Request::BasicAuthentication, FidorApi.configuration.htauth_user, FidorApi.configuration.htauth_password if htauth
        config.request  :url_encoded
        config.response :logger if FidorApi.configuration.logging
        config.response :raise_error
        config.adapter  Faraday.default_adapter
      end
    end
  end

end
