module FidorApi
  module Transfer
    class Base < Connectivity::Resource
      self.endpoint = Connectivity::Endpoint.new('/transfers', :collection)

      attr_accessor :confirmable_action

      def save
        fail InvalidRecordError unless valid?
        super
      end

      def needs_confirmation?
        self.confirmable_action.present?
      end

      private

      def remote_create
        response = super
        if path = response.headers["X-Fidor-Confirmation-Path"]
          self.confirmable_action = ConfirmableAction.new(id: path.split("/").last)
        end
        response
      end

      def remote_update(*attributes)
        response = super
        if path = response.headers["X-Fidor-Confirmation-Path"]
          self.confirmable_action = ConfirmableAction.new(id: path.split("/").last)
        end
        response
      end
    end
  end
end
