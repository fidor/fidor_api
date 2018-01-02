module FidorApi
  class Password < Connectivity::Resource
    extend ModelAttribute

    def self.request_new(email)
      endpoint = Connectivity::Endpoint.new("/password_resets/new_token", :resource, version: "2", tokenless: true)
      response = endpoint.for(self).put(payload: { email: email, type: "reset_token" })
      response.body["success"]
    end

    def self.update(attributes)
      endpoint = Connectivity::Endpoint.new("/password_resets", :collection, version: "2", tokenless: true)
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
