module FidorApi
  class Client
    module DSL
      module Cards
        def cards(options = {})
          fetch(:collection, Model::Card, '/cards', options)
        end

        def card(id, options = {})
          fetch(:single, Model::Card, "/cards/#{id}", options)
        end
      end
    end
  end
end
