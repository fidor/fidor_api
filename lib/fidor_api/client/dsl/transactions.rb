module FidorApi
  class Client
    module DSL
      module Transactions
        def transactions(options = {})
          fetch(:collection, Model::Transaction, 'transactions', options)
        end

        def transaction(id, options = {})
          fetch(:single, Model::Transaction, "transactions/#{id}", options)
        end
      end
    end
  end
end
