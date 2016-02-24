module FidorApi

  class User < Resource
    extend ModelAttribute

    attribute :id,              :integer
    attribute :email,           :string
    attribute :last_sign_in_at, :string
    attribute :created_at,      :time
    attribute :updated_at,      :time

    def self.current(access_token)
      new(request(access_token: access_token, endpoint: "/users/current"))
    end

    module ClientSupport
      def current_user
        User.current(token.access_token)
      end
    end
  end

end
