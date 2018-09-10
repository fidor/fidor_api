module FidorApi
  module Model
    class Card < Base
      attribute :id,                       :integer
      attribute :account_id,               :integer
      attribute :type,                     :string
      attribute :physical,                 :boolean
      attribute :design,                   :string
      attribute :state,                    :string
      attribute :disabled,                 :boolean
      attribute :inscription,              :string
      attribute :balance,                  :integer
      attribute :currency,                 :string
      attribute :atm_limit,                :integer
      attribute :transaction_single_limit, :integer
      attribute :transaction_volume_limit, :integer
      attribute :email_notification,       :boolean
      attribute :sms_notification,         :boolean
      attribute :payed,                    :boolean
      attribute :lock_reason,              :string
      attribute :created_at,               :time
      attribute :updated_at,               :time

      attribute_decimal_methods :balance
      attribute_decimal_methods :atm_limit
      attribute_decimal_methods :transaction_single_limit
      attribute_decimal_methods :transaction_volume_limit
    end
  end
end
