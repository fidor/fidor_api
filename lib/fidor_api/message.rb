module FidorApi

  class Message < Resource
    extend ModelAttribute
    extend AmountAttributes

    attribute :id,         :integer
    attribute :subject,    :string
    attribute :type,       :string
    attribute :opened_at,  :time
    attribute :created_at, :time
    attribute :updated_at, :time
    attribute :category,   :string

    def self.all(access_token, options = {})
      Collection.build(self, request(access_token: access_token, endpoint: "/messages", query_params: options))
    end

    def self.find(access_token, id)
      new(request(access_token: access_token, endpoint: "/messages/#{id}"))
    end

    def self.attachment(access_token, id)
      request(access_token: access_token, endpoint: "/messages/#{id}/attachment")
    end

    module ClientSupport
      def messages(options = {})
        Message.all(token.access_token, options)
      end

      def message(id)
        Message.find(token.access_token, id)
      end

      def message_attachment(id)
        Message.attachment(token.access_token, id)
      end
    end
  end

end