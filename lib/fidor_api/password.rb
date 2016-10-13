module FidorApi
  class Password < Connectivity::Resource
    extend ModelAttribute

    self.endpoint = Connectivity::Endpoint.new("/password_resets", :collection, version: "2", tokenless: true)

    def self.request_new(email)
      params = {email: email, type: "reset_token"}
      response = endpoint.for(self).put(action: "new_token", payload: params)
      response.body["success"]
    end

    def self.update(attributes)
      response = endpoint.for(self).post(payload: attributes)
      response.body["success"]
    end

    private

    module ClientSupport
      def request_new_password(email)
        Password.request_new(email)
      end

      def update_password(attributes)
        Password.update(attributes)
      end
    end
  end
end
