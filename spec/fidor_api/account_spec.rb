require "spec_helper"

describe FidorApi::Account do

  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "f859032a6ca0a4abb2be0583b8347937") }

  before do
    FidorApi::Connectivity.access_token = 'f859032a6ca0a4abb2be0583b8347937'
  end

  describe ".all" do
    it "returns all account records" do
      VCR.use_cassette("account/all", record: :once) do
        accounts = client.accounts
        expect(accounts).to be_instance_of FidorApi::Collection

        account = accounts.first
        expect(account).to be_instance_of FidorApi::Account
        expect(account.id).to                    eq 857
        expect(account.account_number).to        eq "5102606797"
        expect(account.iban).to                  eq "DE47700222005102606797"
        expect(account.bic).to                   be_nil
        expect(account.balance).to               eq BigDecimal.new("-1192.51")
        expect(account.balance_available).to     eq BigDecimal.new("69.82")
        expect(account.preauth_amount).to        eq BigDecimal.new("8.04")
        expect(account.cash_flow_per_year).to    eq BigDecimal.new("56.40")
        expect(account.is_debit_note_enabled).to be true
        expect(account.is_trusted).to            be false
        expect(account.is_locked).to             be false
        expect(account.currency).to              eq "EUR"
        expect(account.overdraft).to             eq BigDecimal.new("250.00")
        expect(account.created_at).to            eq Time.new(2015, 8, 26, 15, 43, 30, "+00:00")
        expect(account.updated_at).to            eq Time.new(2015, 8, 26, 15, 43, 42, "+00:00")

        expect(account.customers).to be_instance_of Array
        customer = account.customers.first
        expect(customer).to be_instance_of FidorApi::Customer
      end
    end
  end

  describe ".first" do
    it "returns the first customer record" do
      VCR.use_cassette("account/first", record: :once) do
        account = client.first_account
        expect(account).to be_instance_of FidorApi::Account
      end
    end
  end

end
