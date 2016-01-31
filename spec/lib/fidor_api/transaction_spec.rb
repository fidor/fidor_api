require "spec_helper"

describe FidorApi::Transaction do

  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "f859032a6ca0a4abb2be0583b8347937") }

  def expect_correct_transaction(transaction)
    expect(transaction).to be_instance_of FidorApi::Transaction
    expect(transaction.id).to                       eq 28170
    expect(transaction.account_id).to               eq "857"
    expect(transaction.transaction_type).to         eq "sepa_payin"
    expect(transaction.subject).to                  eq "Gutschrift 9/2007"
    expect(transaction.amount).to                   eq BigDecimal.new("47.93")
    expect(transaction.currency).to                 be_nil
    expect(transaction.booking_date).to             eq Time.new(2015, 7, 12)
    expect(transaction.value_date).to               eq Time.new(2015, 7, 13)
    expect(transaction.booking_code).to             be_nil
    expect(transaction.return_transaction_id).to    be_nil
    expect(transaction.created_at).to               eq Time.new(2015, 8, 26, 15, 43, 30, "+00:00")
    expect(transaction.updated_at).to               eq Time.new(2015, 8, 26, 15, 43, 30, "+00:00")

    details = transaction.transaction_type_details
    expect(details).to be_instance_of FidorApi::TransactionDetails::Transfer
    expect(details.sepa_credit_transfer_id).to      be_nil
    expect(details.remote_name).to                  eq "Fischer Alexander"
    expect(details.remote_iban).to                  eq "DE90048273272084390548"
    expect(details.remote_bic).to                   eq "DAKVDEFFNL1"
  end

  describe ".all" do
    it "returns all transaction records" do
      VCR.use_cassette("transaction/all", record: :once) do
        transactions = client.transactions
        expect(transactions).to be_instance_of FidorApi::Collection
        expect_correct_transaction(transactions.first)
      end
    end
  end

  describe ".find" do
    it "returns one record" do
      VCR.use_cassette("transaction/find", record: :once) do
        transaction = client.transaction "28170"
        expect_correct_transaction(transaction)
      end
    end
  end

end
