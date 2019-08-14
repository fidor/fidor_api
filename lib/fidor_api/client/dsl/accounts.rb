module FidorApi
  class Client
    module DSL
      module Accounts
        def account_transactions(id, options = {})
          fetch(:collection, Model::Transaction, "accounts/#{id}/transactions", options)
        end

        def account_transaction(account_id, transaction_id, options = {})
          fetch(:single, Model::Transaction, "accounts/#{account_id}/transactions/#{transaction_id}", options)
        end
      end
    end
  end
end
