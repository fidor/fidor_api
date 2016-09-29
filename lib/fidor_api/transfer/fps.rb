module FidorApi
  module Transfer
    class FPS < Base
      extend ModelAttribute
      extend AmountAttributes

      self.endpoint = Connectivity::Endpoint.new('/fps_transfers', :collection)

      attribute :id,               :integer
      attribute :account_id,       :string
      attribute :user_id,          :string
      attribute :transaction_id,   :string
      attribute :remote_account,   :string
      attribute :remote_sort_code, :string
      attribute :remote_name,      :string
      attribute :external_uid,     :string
      attribute :subject,          :string
      attribute :currency,         :string
      attribute :subject,          :string
      attribute :state,            :string
      attribute :created_at,       :time
      attribute :updated_at,       :time
      amount_attribute :amount

      def self.required_attributes
        [ :account_id, :external_uid, :remote_account, :remote_sort_code, :remote_name, :amount, :subject ]
      end

      def self.writeable_attributes
        required_attributes
      end

      validates *required_attributes, presence: true

      def as_json
        attributes.slice *self.class.writeable_attributes
      end

      private

      module ClientSupport
        def fps_transfers(options = {})
          Transfer::FPS.all(options)
        end

        def fps_transfer(id)
          Transfer::FPS.find(id)
        end

        def build_fps_transfer(attributes = {})
          Transfer::FPS.new(attributes)
        end
      end
    end
  end
end
