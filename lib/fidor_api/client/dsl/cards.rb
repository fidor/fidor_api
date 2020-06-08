module FidorApi
  class Client
    module DSL
      module Cards
        def cards(options = {})
          fetch(:collection, Model::Card, 'cards', options)
        end

        def card(id, options = {})
          fetch(:single, Model::Card, "cards/#{id}", options)
        end

        def create_card(attributes = {}, options = {})
          create(FidorApi::Model::Card, 'cards', attributes, options)
        end
      end
    end
  end
end
