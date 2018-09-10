module FidorApi
  module Model
    class Transaction < Base
      attribute :id,                       :integer
      attribute :account_id,               :string
      attribute :transaction_type,         :string
      attribute :transaction_type_details, :json
      attribute :subject,                  :string
      attribute :amount,                   :integer
      attribute :booking_code,             :string
      attribute :booking_date,             :time
      attribute :value_date,               :time
      attribute :return_transaction_id,    :string
      attribute :currency,                 :string
      attribute :created_at,               :time
      attribute :updated_at,               :time

      attribute_decimal_methods :amount
    end
  end
end
