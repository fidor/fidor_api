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
          request.headers["Authorization"] = "Bearer #{options[:access_token]}" if options[:access_token]
          request.headers["Accept"]        = "application/vnd.fidor.de; version=#{options[:version]},text/json"
          request.headers["Content-Type"]  = "application/json"
          if options[:body] && options[:body].is_a?(Hash)
            request.body = options[:body].to_json
          elsif options[:body].present?
            request.body = options[:body]
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
        when 422
          body = JSON.parse(e.response[:body])
          raise ValidationError.new(body["message"], body["errors"])
        else
          raise ClientError
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

      def faraday
        @faraday ||= Faraday.new(url: FidorApi.configuration.api_url, ssl: { verify: FidorApi.configuration.verify_ssl }) do |config|
          if FidorApi.configuration.htauth_user.present? && FidorApi.configuration.htauth_password.present?
            config.use Faraday::Request::BasicAuthentication, FidorApi.configuration.htauth_user, FidorApi.configuration.htauth_password
          end
          config.request  :url_encoded
          config.response logger_type, FidorApi.configuration.logger if FidorApi.configuration.logging
          config.response :raise_error
          config.adapter  Faraday.default_adapter
        end
      end
    end
  end
end
