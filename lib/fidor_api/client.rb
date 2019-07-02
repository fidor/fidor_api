module FidorApi
  class Client
    autoload :Authentication, 'fidor_api/client/authentication'
    autoload :Configuration,  'fidor_api/client/configuration'
    autoload :Connection,     'fidor_api/client/connection'
    autoload :DSL,            'fidor_api/client/dsl'

    include Authentication
    include DSL

    deprecator = ActiveSupport::Deprecation.new('2.2', 'fidor_api')
    ActiveSupport::Deprecation.deprecate_methods(self, confirm_transfer: 'Migrate to create_transfer_confirmation', deprecator: deprecator)

    attr_accessor :config

    def initialize
      self.config = Configuration.new
      yield(config) if block_given?
      config.validate!
    end

    def connection(host: config.environment.api_host)
      Connection.new(client: self, host: host)
    end
  end
end
