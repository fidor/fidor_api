module FidorApi
  module Connectivity
    module Connection
      extend self

      Response = Struct.new(:status, :headers, :raw_body) do
        def body
          if headers["content-type"] =~ /json/
            JSON.parse(raw_body)
          else
            raw_body
          end
        end
      end

      def get(path, options={})
        request(:get, path, options)
      end

      def post(path, options={})
        request(:post, path, options)
      end

      def put(path, options={})
        request(:put, path, options)
      end

      def delete(path, options={})
        request(:delete, path, options)
      end

      def with_token(token)
        self.access_token = token
        yield
      end

      private

      def request(method, path, options={})
        options.reverse_merge! version: 1, access_token: Connectivity.access_token
        response = faraday.public_send(method, [FidorApi.configuration.api_path, path].compact.join) do |request|
          request.params = options[:query_params] if options[:query_params]
          request.headers = {}
          if options[:access_token]
            request.headers["Authorization"] = "Bearer #{options[:access_token]}"
          else
            request.headers["Authorization"] = tokenless_http_basic_header
          end
          request.headers["Accept"]        = "application/vnd.fidor.de; version=#{options[:version]},text/json"
          request.headers["Content-Type"]  = "application/json"
          if options[:body]
            if options[:body].is_a?(String)
              request.body = options[:body]
            elsif options[:body].respond_to?(:to_json)
              request.body = options[:body].to_json
            else
              fail ArgumentError, "unhandled body type #{options[:body].inspect}"
            end
          end
        end
        if response.status == 303 && URI.parse(response.headers["Location"]).path =~ /^(\/fidor_api)?\/confirmable\//
          confirmable_action = ConfirmableAction.new(id: URI.parse(response.headers["Location"]).path.split("/").last)
          raise ApprovalRequired.new(confirmable_action)
        end
        Response.new(response.status, response.headers, response.body)
      rescue Faraday::Error::ClientError => e
        log :info,  "Error (#{e.class.name}): #{e.to_s}\nStatus: #{e.response[:status]}"
        log :debug, "Header: #{e.response[:header]}\nBody: #{e.response[:body]}"
        case e.response[:status]
        when 401
          raise UnauthorizedTokenError
        when 403
          body = JSON.parse(e.response[:body])
          raise ForbiddenError.new(body["message"], body["code"], body["key"])
        when 422
          body = JSON.parse(e.response[:body])
          raise ValidationError.new(body["message"], body["errors"], body["key"])
        else
          body = JSON.parse(e.response[:body])
          raise ClientError.new(body["message"], body["code"], body["key"])
        end
      end

      def log(level, message)
        return unless FidorApi.configuration.logging
        FidorApi.configuration.logger.public_send(level, message)
      end

      def logger_type
        if defined?(Faraday::DetailedLogger)
          :detailed_logger
        else
          :logger
        end
      end

      def tokenless_http_basic_header
        @tokenless_http_basic_header ||= begin
          base64 = Base64.strict_encode64("#{FidorApi.configuration.htauth_user}:#{FidorApi.configuration.htauth_password}")
          "Basic #{base64}"
        end
      end

      def faraday
        @faraday ||= Faraday.new(url: FidorApi.configuration.api_url, ssl: { verify: FidorApi.configuration.verify_ssl }) do |config|
          config.request  :url_encoded
          config.response logger_type, FidorApi.configuration.logger if FidorApi.configuration.logging
          config.response :raise_error
          config.adapter  Faraday.default_adapter
        end
      end
    end
  end
end
