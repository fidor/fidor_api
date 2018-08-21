module FidorApi
  class Client
    module DSL
      module CoreData
        def user(options = {})
          fetch(:single, Model::User, '/users/current', options)
        end

        def customers(options = {})
          fetch(:collection, Model::Customer, '/customers', options)
        end

        def accounts(options = {})
          fetch(:collection, Model::Account, '/accounts', options)
        end
      end
    end
  end
end
