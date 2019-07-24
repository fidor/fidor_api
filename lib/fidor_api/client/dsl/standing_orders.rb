module FidorApi
  class Client
    module DSL
      module StandingOrders
        def standing_orders(options = {})
          fetch(:collection, FidorApi::Model::StandingOrder, 'standing_orders', options[:headers])
        end

        def standing_order(id, options = {})
          fetch(:single, FidorApi::Model::StandingOrder, "standing_orders/#{id}", options)
        end

        def new_standing_order(attributes = {})
          FidorApi::Model::StandingOrder.new(attributes)
        end

        def create_standing_order(attributes = {}, options = {})
          create(FidorApi::Model::StandingOrder, 'standing_orders', attributes, options)
        end

        def update_standing_order(id, attributes = {}, options = {})
          update(FidorApi::Model::StandingOrder, "standing_orders/#{id}", id, attributes, options)
        end

        def confirm_standing_order(id, options = {})
          request(:put, "standing_orders/#{id}/confirm", {}, options[:headers])
        end
      end
    end
  end
end
