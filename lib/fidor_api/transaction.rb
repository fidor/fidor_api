module FidorApi
  class Transaction < Connectivity::Resource
    extend ModelAttribute
    extend AmountAttributes

    self.endpoint = Connectivity::Endpoint.new('/transactions', :collection)

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

    def transaction_type_details
      @_transaction_type_details ||= TransactionDetails.build(@transaction_type, @transaction_type_details)
    end

    module ClientSupport
      def transactions(options = {})
        Transaction.all(options)
      end

      def transaction(id)
        Transaction.find(id)
      end
    end
  end

end
