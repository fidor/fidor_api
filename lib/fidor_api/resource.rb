module FidorApi

  class Resource
    include ActiveModel::Model

    attr_accessor :client, :confirmable_action

    class Response
      include ActiveModel::Model

      attr_accessor :status, :headers, :body

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
      Response.new(status: response.status, headers: response.headers, body: response.body)
    rescue Faraday::Error::ClientError => e
      log :info,  "Error (#{e.class.name}): #{e.to_s}\nStatus: #{e.response[:status]}"
      log :debug, "Header: #{e.response[:header]}\nBody: #{e.response[:body]}"
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

    def self.log(level, message)
      return unless FidorApi.configuration.logging
      FidorApi.configuration.logger.public_send(level, message)
    end

    def persisted?
      id.present?
    end

    def needs_confirmation?
      self.confirmable_action.present?
    end

    private

    def self.connection(htauth: false)
      Faraday.new(url: FidorApi.configuration.api_url, ssl: { verify: FidorApi.configuration.verify_ssl }) do |config|
        config.use      Faraday::Request::BasicAuthentication, FidorApi.configuration.htauth_user, FidorApi.configuration.htauth_password if htauth
        config.request  :url_encoded
        config.response logger_type, FidorApi.configuration.logger if FidorApi.configuration.logging
        config.response :raise_error
        config.adapter  Faraday.default_adapter
      end
    end

    def self.logger_type
      if defined?(Faraday::DetailedLogger)
        :detailed_logger
      else
        :logger
      end
    end

    def create(options = {})
      raise InvalidRecordError unless valid?
      response = self.class.request({ method: :post, access_token: client.try { |c| c.token.access_token }, endpoint: self.class.resource, body: as_json }.merge(options))
      if path = response.headers["X-Fidor-Confirmation-Path"]
        self.confirmable_action = ConfirmableAction.new(id: path.split("/").last.to_i)
      end
      initialize(response.body)
      true
    rescue ValidationError => e
      map_errors(e.fields)
      false
    end

    def map_errors(fields)
      fields.each do |hash|
        key = hash["field"].to_sym
        errors.add(hash["field"].to_sym, hash["message"]) if key == :base || respond_to?(key)
      end
    end
  end

end
