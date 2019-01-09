module FidorApi
  class Client
    module DSL
      module Accounts
        def account_transactions(id, options = {})
          fetch(:collection, Model::Transaction, "accounts/#{id}/transactions", options)
        end
      end
    end
  end
end
