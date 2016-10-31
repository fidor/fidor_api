module FidorApi
  module Connectivity
    extend self

    autoload :Connection, 'fidor_api/connectivity/connection'
    autoload :Resource, 'fidor_api/connectivity/resource'
    autoload :Endpoint, 'fidor_api/connectivity/endpoint'

    def access_token=(val)
      Thread.current[:fidor_api_access_token] = val
    end

    def access_token
      Thread.current[:fidor_api_access_token]
    end
  end
end
