module FidorApi
  module Environment
    module FidorDE
      class Production < Base
        def api_host
          'https://api.fidor.de'.freeze
        end

        def auth_host
          'https://apm.fidor.de'.freeze
        end

        def auth_redirect_host
          'https://apm.fidor.de'.freeze
        end

        def auth_methods
          %i[authorization_code].freeze
        end

        def transfers_api
          :classic
        end
      end
    end
  end
end
