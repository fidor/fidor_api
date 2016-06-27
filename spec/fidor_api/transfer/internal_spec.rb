require "spec_helper"

describe FidorApi::Transfer::Internal do

  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "f859032a6ca0a4abb2be0583b8347937") }

  subject do
    client.build_internal_transfer(
      account_id:   875,
      receiver:     "kycfull@fidor.de",
      external_uid: "4279762F5",
      subject:      "Money for you",
      amount:       BigDecimal.new("10.00")
    )
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :account_id   }
    it { is_expected.to validate_presence_of :receiver     }
    it { is_expected.to validate_presence_of :external_uid }
    it { is_expected.to validate_presence_of :amount       }
    it { is_expected.to validate_presence_of :subject      }
  end

  describe "#save" do
    context "on success" do
      it "returns true and updates the attributes with received data" do
        VCR.use_cassette("transfer/internal/save_success", record: :once) do
          expect(subject.save).to be true

          expect(subject.id).to    eq 2366
          expect(subject.state).to eq "received"
        end
      end
    end

    context "on invalid object" do
      it "raises an error" do
        subject.account_id = nil

        expect { subject.save}.to raise_error FidorApi::InvalidRecordError
      end
    end

    context "on failure response" do
      it "returns false and provides errors" do
        subject.account_id = 999

        VCR.use_cassette("transfer/internal/save_failure", record: :once) do
          expect(subject.save).to be false
          expect(subject.errors[:base]      ).to eq ["something global"]
          expect(subject.errors[:account_id]).to eq ["something specific"]
        end
      end
    end
  end

  describe "#as_json" do
    it "returns all writeable fields" do
      expect(subject.as_json).to eq(
        account_id:   "875",
        amount:       1000,
        external_uid: "4279762F5",
        receiver:     "kycfull@fidor.de",
        subject:      "Money for you"
      )
    end
  end

  def expect_correct_transfer(transfer)
    expect(transfer).to be_instance_of FidorApi::Transfer::Internal
    expect(transfer.id).to             eq 2366
    expect(transfer.account_id).to     eq "875"
    expect(transfer.user_id).to        eq "875"
    expect(transfer.transaction_id).to eq "28836"
    expect(transfer.receiver).to       eq "kycfull@fidor.de"
    expect(transfer.external_uid).to   eq "4279762F5"
    expect(transfer.amount).to         eq BigDecimal.new("10.00")
    expect(transfer.currency).to       be_nil
    expect(transfer.subject).to        eq "Money for you"
    expect(transfer.state).to          eq "success"
    expect(transfer.created_at).to     eq Time.new(2015, 9, 12, 0, 10, 57, "+00:00")
    expect(transfer.updated_at).to     eq Time.new(2015, 9, 12, 0, 11,  6, "+00:00")
  end

  describe ".all" do
    it "returns all transfer records" do
      VCR.use_cassette("transfer/internal/all", record: :once) do
        transfers = client.internal_transfers
        expect(transfers).to be_instance_of FidorApi::Collection
        expect_correct_transfer transfers.first
      end
    end
  end

  describe ".find" do
    it "returns one record" do
      VCR.use_cassette("transfer/internal/find", record: :once) do
        transfer = client.internal_transfer 2366
        expect(transfer).to be_instance_of FidorApi::Transfer::Internal
        expect_correct_transfer transfer
      end
    end
  end
end