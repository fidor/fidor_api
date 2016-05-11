module FidorApi

  class Resource
    include ActiveModel::Model

    attr_accessor :client

    class Response
      include ActiveModel::Model

      attr_accessor :headers, :body

      def body
        if headers["content-type"] =~ /json/
          JSON.parse(@body)
        else
          @body
        end
      end
    end

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
      Response.new(headers: response.headers, body: response.body)
    rescue Faraday::Error::ClientError => e
      case e.response[:status]
      when 401
        raise UnauthorizedTokenError
      when 422
        body = JSON.parse(e.response[:body])
        raise ValidationError.new(body["message"], body["errors"])
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

    def create(options = {})
      raise InvalidRecordError unless valid?
      set_attributes self.class.request({ method: :post, access_token: client.try { |c| c.token.access_token }, endpoint: self.class.resource, body: as_json }.merge(options)).body
      true
    rescue ValidationError => e
      map_errors(e.fields)
      false
    end

    def map_errors(fields)
      fields.each do |hash|
        errors.add(hash["field"].to_sym, hash["message"]) if respond_to? hash["field"].to_sym
      end
    end
  end

end
