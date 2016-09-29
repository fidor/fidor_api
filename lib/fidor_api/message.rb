module FidorApi
  class Message < Connectivity::Resource
    extend ModelAttribute
    extend AmountAttributes

    self.endpoint = Connectivity::Endpoint.new('/messages', :collection)

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

    def attachment
      response = endpoint.for(self).get(action: 'attachment')
      Attachment.new(
        type:     response.headers["content-type"],
        filename: response.headers["content-disposition"][/filename="([^"]+)"/, 1],
        content:  response.body,
      )
    end

    def content
      endpoint.for(self).get(action: 'content').body
    end

    module ClientSupport
      def messages(options = {})
        Message.all(options)
      end

      def message(id)
        Message.find(id)
      end

      def message_attachment(id)
        Message.new(id: id).attachment
      end

      def message_content(id)
        Message.new(id: id).content
      end
    end
  end
end
