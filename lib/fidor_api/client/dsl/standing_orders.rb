module FidorApi
  class Client
    module DSL
      module StandingOrders
        def standing_order(id, options = {})
          fetch(:single, FidorApi::Model::StandingOrder, "/standing_orders/#{id}", options)
        end

        def new_standing_order(attributes = {})
          FidorApi::Model::StandingOrder.new(attributes)
        end

        def create_standing_order(attributes = {})
          create(FidorApi::Model::StandingOrder, '/standing_orders', attributes)
        end
      end
    end
  end
end
