module FidorApi
  module Environment
    class Future < Base
      def api_host
        'https://api.example.com'.freeze
      end

      def auth_host
        'https://api.example.com'.freeze
      end

      def auth_redirect_host
        'https://auth.example.com'.freeze
      end

      def auth_methods
        %i[authorization_code resource_owner_password_credentials client_credentials].freeze
      end

      def transfers_api
        :generic
      end
    end
  end
end
