module FidorApi
  module Model
    module Transfer
      module Classic
        class SEPA < Base
          attribute :id,           :integer
          attribute :account_id,   :string
          attribute :external_uid, :string
          attribute :remote_name,  :string
          attribute :remote_iban,  :string
          attribute :remote_bic,   :string
          attribute :amount,       :integer
          attribute :subject,      :string
          attribute :state,        :string
          attribute :created_at,   :time
          attribute :updated_at,   :time

          attribute_decimal_methods :amount
        end
      end
    end
  end
end
