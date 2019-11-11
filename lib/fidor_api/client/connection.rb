module FidorApi
  class Client
    class Connection
      DEFAULT_HEADERS = {
        'Accept'       => 'application/vnd.fidor.de; version=1,text/json',
        'Content-Type' => 'application/json'
      }.freeze

      def initialize(client:, host:)
        @client = client
        @host   = host
      end

      %i[get post put patch delete].each do |method|
        define_method method do |path, query: nil, body: nil, headers: {}, auth: nil|
          request(
            path:    path,
            method:  method,
            query:   query,
            body:    body,
            headers: DEFAULT_HEADERS.merge(headers),
            auth:    auth
          )
        end
      end

      private

      attr_accessor :client, :host

      def request(path:, method: :get, query: {}, body: {}, headers: {}, auth: nil) # rubocop:disable Metrics/ParameterLists
        payload = method == :get ? query : body&.to_json

        response = faraday(auth: auth).public_send(method, path, payload) do |request|
          request.headers = headers
        end

        response
      rescue Faraday::ClientError => e
        client.config.logger.error e.inspect if client.config.logger # rubocop:disable Style/SafeNavigation
        raise
      end

      def faraday(auth:) # rubocop:disable Metrics/AbcSize
        Faraday.new(url: host, ssl: { verify: client.config.verify_ssl }) do |config|
          config.use Faraday::Request::BasicAuthentication, *auth if auth.is_a? Array
          config.request :oauth2, client.token.access_token, token_type: :bearer if client.token
          config.response :logger, client.config.logger, bodies: client.config.log_bodies if client.config.logger
          config.response :raise_error
          config.response :json, content_type: /json/
          client.config.faraday.call(config)
          config.adapter Faraday.default_adapter
        end
      end
    end
  end
end
