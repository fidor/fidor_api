module FidorApi
  class Client
    module DSL
      module DebitReturns
        def debit_return(transaction_id, options = {})
          fetch(:single, Model::DebitReturn, "transactions/#{transaction_id}/debit_return", options)
        end

        def create_debit_return(transaction_id, options = {})
          create(FidorApi::Model::DebitReturn, "transactions/#{transaction_id}/debit_return", {}, options)
        end

        def confirm_debit_return(transaction_id, options = {})
          request(:put, "/transactions/#{transaction_id}/debit_return/confirm", {}, options[:headers] || {})
        end
      end
    end
  end
end
