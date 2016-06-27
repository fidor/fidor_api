module FidorApi
  module Transfer
    class Base < Resource
      def save
        if id.nil?
          create
        else
          raise NoUpdatesAllowedError
        end
      end

      def self.all(access_token, options = {})
        Collection.build(self, request(access_token: access_token, endpoint: resource, query_params: options).body)
      end

      def self.find(access_token, id)
        new(request(access_token: access_token, endpoint: "/#{resource}/#{id}").body)
      end
    end
  end
end
