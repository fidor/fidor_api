module FidorApi
  module Model
    class Account < Base
      attribute :id,                    :integer
      attribute :account_number,        :string
      attribute :iban,                  :string
      attribute :bic,                   :string
      attribute :balance,               :integer
      attribute :balance_available,     :integer
      attribute :overdraft,             :integer
      attribute :preauth_amount,        :integer
      attribute :cash_flow_per_year,    :integer
      attribute :is_debit_note_enabled, :string
      attribute :is_trusted,            :string
      attribute :is_locked,             :string
      attribute :currency,              :string

      attribute_decimal_methods :balance
      attribute_decimal_methods :balance_available
      attribute_decimal_methods :overdraft
      attribute_decimal_methods :preauth_amount
      attribute_decimal_methods :cash_flow_per_year
    end
  end
end
