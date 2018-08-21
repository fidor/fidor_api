module FidorApi
  module Model
    class Message < Base
      attribute :id,         :integer
      attribute :subject,    :string
      attribute :type,       :string
      attribute :opened_at,  :time
      attribute :created_at, :time
      attribute :updated_at, :time
      attribute :category,   :string

      class Content < Base
        attribute :raw, :string
      end

      class Attachment < Base
        attribute :filename, :string
        attribute :type,     :string
        attribute :content,  :string
      end
    end
  end
end
