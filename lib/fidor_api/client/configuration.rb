require 'logger'

module FidorApi
  class Client
    class Configuration
      ATTRIBUTES = %i[
        environment
        client_id
        client_secret
        logger
        log_bodies
        verify_ssl
        faraday
      ].freeze

      attr_accessor(*ATTRIBUTES)

      def initialize
        self.environment = Environment::FidorDE::Sandbox.new
        self.logger      = Logger.new(STDOUT)
        self.log_bodies  = true
        self.verify_ssl  = true
        self.faraday     = ->(faraday) {}
      end

      def validate!
        ATTRIBUTES.each do |key|
          raise "Missing config value for `#{key}`!" \
            if instance_variable_get("@#{key}").nil?
        end
      end
    end
  end
end
