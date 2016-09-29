module FidorApi
  class Account < Connectivity::Resource
    extend ModelAttribute
    extend AmountAttributes

    self.endpoint = Connectivity::Endpoint.new('/accounts', :collection)

    attribute :id,                    :integer
    attribute :account_number,        :string
    attribute :iban,                  :string
    attribute :bic,                   :string
    attribute :is_debit_note_enabled, :boolean
    attribute :is_trusted,            :boolean
    attribute :is_locked,             :boolean
    attribute :currency,              :string
    attribute :created_at,            :time
    attribute :updated_at,            :time
    attribute :customers,             :string

    amount_attribute :balance
    amount_attribute :balance_available
    amount_attribute :preauth_amount
    amount_attribute :cash_flow_per_year
    amount_attribute :overdraft

    def self.first
      all(page: 1, per_page: 1).first
    end

    def customers=(array)
      @customers = array.map { |customer| Customer.new(customer) }
    end

    module ClientSupport
      def accounts(options = {})
        Account.all(options)
      end

      def first_account
        Account.first
      end
    end
  end

end
