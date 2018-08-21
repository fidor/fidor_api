module FidorApi
  module Model
    module Transfer
      module Classic
        class Internal < Base
          attribute :id,           :integer
          attribute :account_id,   :string
          attribute :external_uid, :string
          attribute :receiver,     :string
          attribute :amount,       :integer
          attribute :subject,      :string
          attribute :created_at,   :time
          attribute :updated_at,   :time

          attribute_decimal_methods :amount
        end
      end
    end
  end
end
