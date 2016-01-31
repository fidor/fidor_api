module FidorApi

  class Transaction < Resource
    extend ModelAttribute
    extend AmountAttributes

    attribute :id,                       :integer
    attribute :account_id,               :string
    attribute :transaction_type,         :string
    attribute :transaction_type_details, :json
    attribute :subject,                  :string
    attribute :currency,                 :string
    attribute :booking_date,             :time
    attribute :value_date,               :time
    attribute :booking_code,             :string
    attribute :return_transaction_id,    :string
    attribute :created_at,               :time
    attribute :updated_at,               :time
    amount_attribute :amount

    def self.all(access_token, options = {})
      Collection.build(self, request(:get, access_token, "/transactions", options))
    end

    def self.find(access_token, id)
      new(request(:get, access_token, "/transactions/#{id}"))
    end

    def transaction_type_details
      @_transaction_type_details ||= TransactionDetails.build(@transaction_type, @transaction_type_details)
    end

    module ClientSupport
      def transactions(options = {})
        Transaction.all(token.access_token, options)
      end

      def transaction(id)
        Transaction.find(token.access_token, id)
      end
    end
  end

end
