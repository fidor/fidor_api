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

    class Attachment
      include ActiveModel::Model
      attr_accessor :type, :filename, :content
    end

    def self.all(access_token, options = {})
      Collection.build(self, request(access_token: access_token, endpoint: "/messages", query_params: options).body)
    end

    def self.find(access_token, id)
      new(request(access_token: access_token, endpoint: "/messages/#{id}").body)
    end

    def self.attachment(access_token, id)
      response = request(access_token: access_token, endpoint: "/messages/#{id}/attachment")

      Attachment.new(
        type:     response.headers["content-type"],
        filename: response.headers["content-disposition"][/filename="([^"]+)"/, 1],
        content:  response.body,
      )
    end

    def self.content(access_token, id)
      request(access_token: access_token, endpoint: "/messages/#{id}/content").body
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

      def message_content(id)
        Message.content(token.access_token, id)
      end
    end
  end

end