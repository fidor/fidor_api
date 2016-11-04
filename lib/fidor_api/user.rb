module FidorApi
  class User < Connectivity::Resource
    extend ModelAttribute

    self.endpoint = Connectivity::Endpoint.new('/users', :collection)

    attribute :id,                  :integer
    attribute :email,               :string
    attribute :msisdn_activated_at, :time
    attribute :last_sign_in_at,     :string
    attribute :created_at,          :time
    attribute :updated_at,          :time

    def self.current
      new endpoint.for(self).get(action: 'current').body
    end

    module ClientSupport
      def current_user
        User.current
      end
    end
  end
end
