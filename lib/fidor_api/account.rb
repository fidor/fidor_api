module FidorApi

  class Account < Resource
    extend ModelAttribute

    attribute :id,                    :integer
    attribute :account_number,        :string
    attribute :iban,                  :string
    attribute :bic,                   :string
    attribute :balance,               :integer
    attribute :balance_available,     :integer
    attribute :preauth_amount,        :integer
    attribute :cash_flow_per_year,    :integer
    attribute :is_debit_note_enabled, :boolean
    attribute :is_trusted,            :boolean
    attribute :is_locked,             :boolean
    attribute :currency,              :string
    attribute :overdraft,             :integer
    attribute :created_at,            :time
    attribute :updated_at,            :time
    attribute :customers,             :string

    def self.all(access_token, options = {})
      Collection.build(self, request(:get, access_token, "/accounts", options))
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
