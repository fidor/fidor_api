module FidorApi
  class ConfirmableAction < Resource
    extend ModelAttribute

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

    def self.find(access_token, id)
      new(request(access_token: access_token, endpoint: "/confirmable/actions/#{id}").body)
    end

    def self.update(access_token, id, attributes)
      new(request({ method: :put, access_token: access_token, endpoint: "/confirmable/actions/#{id}", body: attributes}).body)
    end

    module ClientSupport
      def confirmable_actions(options = {})
        ConfirmableAction.all(token.access_token, options)
      end

      def confirmable_action(id)
        ConfirmableAction.find(token.access_token, id)
      end

      def update_confirmable_action(id, attributes)
        ConfirmableAction.update(token.access_token, id, attributes)
      end
    end
  end
end
