module FidorApi
  module Connectivity
    extend self

    autoload :Connection, 'fidor_api/connectivity/connection'
    autoload :Resource, 'fidor_api/connectivity/resource'
    autoload :Endpoint, 'fidor_api/connectivity/endpoint'

    attr_accessor :access_token
  end
end
