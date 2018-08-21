module FidorApi
  class Client
    module DSL
      module ConfirmableActions
        def confirmable_action(id, options = {})
          fetch(:single, Model::ConfirmableAction, "/confirmable/actions/#{id}", options)
        end

        def refresh_confirmable_action(id, options = {})
          update(Model::ConfirmableAction, "/confirmable/actions/#{id}/refresh", id, options)
        end

        def update_confirmable_action(id, attributes = {})
          update(Model::ConfirmableAction, "/confirmable/actions/#{id}", id, attributes)
        end
      end
    end
  end
end
