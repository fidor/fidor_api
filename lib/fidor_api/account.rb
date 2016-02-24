module FidorApi

  class Account < Resource
    extend ModelAttribute
    extend AmountAttributes

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

    def self.all(access_token, options = {})
      Collection.build(self, request(access_token: access_token, endpoint: "/accounts", query_params: options))
    end

    def self.first(access_token)
      all(access_token, page: 1, per_page: 1).first
    end

    def customers=(array)
      @customers = array.map { |customer| Customer.new(customer) }
    end

    module ClientSupport
      def accounts(options = {})
        Account.all(token.access_token, options)
      end

      def first_account
        Account.first(token.access_token)
      end
    end
  end

end
