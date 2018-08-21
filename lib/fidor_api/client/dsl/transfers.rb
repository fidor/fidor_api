module FidorApi
  class Client
    module DSL
      module Transfers
        autoload :Classic, 'fidor_api/client/dsl/transfers/classic'
        autoload :Generic, 'fidor_api/client/dsl/transfers/generic'

        def self.included(klass)
          klass.include Transfers::Classic
          klass.include Transfers::Generic
        end

        private

        def check_transfer_support!(type)
          raise Errors::NotSupported \
            unless config.environment.transfers_api == type
        end
      end
    end
  end
end
