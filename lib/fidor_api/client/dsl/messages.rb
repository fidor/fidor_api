module FidorApi
  class Client
    module DSL
      module Messages
        def messages(options = {})
          fetch(:collection, Model::Message, '/messages', options)
        end

        def message(id, options = {})
          fetch(:single, Model::Message, "/messages/#{id}", options)
        end

        def message_attachment(id)
          response = connection.get("/messages/#{id}/attachment")

          Model::Message::Attachment.new(
            type:     response.headers['content-type'],
            filename: response.headers['content-disposition'][/filename="([^"]+)"/, 1],
            content:  response.body
          )
        end

        def message_content(id)
          response = connection.get("/messages/#{id}/content")

          Model::Message::Content.new(raw: response.body)
        end
      end
    end
  end
end
