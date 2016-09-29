module FidorApi
  class ConfirmableAction < Connectivity::Resource
    extend ModelAttribute

    self.endpoint = Connectivity::Endpoint.new('/confirmable/actions', :collection)

    attribute :id,              :string
    attribute :type,            :string
    attribute :message,         :string
    attribute :steps_left,      :json
    attribute :steps_completed, :json
    attribute :resource,        :json
    attribute :succeeded_at,    :time
    attribute :failed_at,       :time
    attribute :errored_at,      :time
    attribute :created_at,      :time
    attribute :updated_at,      :time

    attribute :otp,             :string

    def refresh
      endpoint.for(self).put(action: "refresh")
      true
    end

    module ClientSupport
      def confirmable_actions(options = {})
        ConfirmableAction.all
      end

      def confirmable_action(id)
        ConfirmableAction.find(id)
      end

      def update_confirmable_action(id, attributes)
        ConfirmableAction.new(attributes.merge(id: id)).tap(&:save)
      end

      def refresh_confirmable_action(id)
        ConfirmableAction.new(id: id).refresh
      end
    end
  end
end
