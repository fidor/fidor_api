module FidorApi
  module Model
    class Preauth < Base
      attribute :id,                   :integer
      attribute :preauth_type_details, :json
      attribute :preauth_type,         :string
      attribute :amount,               :integer
      attribute :expires_at,           :time
      attribute :created_at,           :time
      attribute :updated_at,           :time

      attribute_decimal_methods :amount
    end
  end
end
