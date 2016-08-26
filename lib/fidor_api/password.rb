module FidorApi
  class Password < Resource
    extend ModelAttribute

    def self.request_new(email)
      params = {email: email, type: "reset_token"}

      response = request(method: :put, version: '2', endpoint: "/password_resets/new_token", body: params, htauth: true)

      response.body["success"]
    end

    def self.update(attributes)
      response = request(method: :post, version: '2', endpoint: "/password_resets/", body: attributes, htauth: true)

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
