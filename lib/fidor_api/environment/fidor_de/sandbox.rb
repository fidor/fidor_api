module FidorApi
  module Environment
    module FidorDE
      class Sandbox < Base
        def api_host
          'https://api.sandbox.fidor.com'.freeze
        end

        def auth_host
          'https://apm.sandbox.fidor.com'.freeze
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
