require "spec_helper"

describe FidorApi::Transfer::ACH do

  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "f859032a6ca0a4abb2be0583b8347937") }

  subject do
    client.build_ach_transfer(
      account_id:             "65753938",
      external_uid:           "4279762F8",
      contact_name:           "John Doe",
      contact_address_line_1: "Street 123",
      bank_name:              "Bank Name",
      bank_address_line_1:    "Street 456",
      account_number:         "1234567890",
      routing_code:           "123456789",
      amount:                 BigDecimal.new("10.00"),
      currency:               "USD",
      subject:                "Money for you"
    )
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :account_id       }
    it { is_expected.to validate_presence_of :external_uid     }
    it { is_expected.to validate_presence_of :contact_name     }
    it { is_expected.to validate_presence_of :account_number   }
    it { is_expected.to validate_presence_of :routing_code     }
    it { is_expected.to validate_presence_of :amount           }
    it { is_expected.to validate_presence_of :subject          }
  end

  describe "#save" do
    context "on success" do
      it "returns true and updates the attributes with received data" do
        VCR.use_cassette("transfer/ach/save_success", record: :once) do
          expect(subject.save).to be true

          expect(subject.id).to    eq "ba8930f5-f361-4cc6-acbb-0b5affb4148c"
          expect(subject.state).to eq "pending_backoffice_transfer"
        end
      end
    end

    context "on invalid object" do
      it "raises an error" do
        subject.account_id = nil

        expect { subject.save }.to raise_error FidorApi::InvalidRecordError
      end
    end

    context "on failure response" do
      it "returns false and provides errors" do
        subject.account_id = 999

        VCR.use_cassette("transfer/ach/save_failure", record: :once) do
          expect(subject.save).to be false
          expect(subject.errors[:account_id]).to eq ["should be the token user's account id"]
          expect(subject.errors[:account_number]).to eq ["invalid"]
        end
      end
    end
  end

  describe "#as_json" do
    it "returns all writeable fields" do
      expect(subject.as_json).to eq(
        account_id: "65753938",
        amount: 1000,
        beneficiary: {
          contact: {
            name:           "John Doe",
            address_line_1: "Street 123"
          },
          bank: {
            name:           "Bank Name",
            address_line_1: "Street 456"

          },
          routing_type: "ACH",
          routing_info: {
            account_number: "1234567890",
            routing_code: "123456789"
          }
        },
        currency: "USD",
        external_uid: "4279762F8",
        subject: "Money for you"
      )
    end
  end

  def expect_correct_transfer(transfer)
    expect(transfer).to be_instance_of FidorApi::Transfer::ACH
    expect(transfer.id).to             eq "5f44f7d0-fb4d-4e16-816b-702aa24c27d0"
    expect(transfer.account_id).to     eq "65753938"
    expect(transfer.external_uid).to   eq "d75286a83be91771"
    expect(transfer.contact_name).to   eq "Homer J. Simpson"
    expect(transfer.account_number).to eq "1234567890"
    expect(transfer.routing_code).to   eq "123456789"
    expect(transfer.amount).to         eq BigDecimal.new("4.56")
    expect(transfer.subject).to        eq "ACH Test"
  end

  describe ".all" do
    it "returns all transfer records" do
      VCR.use_cassette("transfer/ach/all", record: :once) do
        transfers = client.ach_transfers
        expect(transfers).to be_instance_of FidorApi::Collection
        expect_correct_transfer transfers.first
      end
    end
  end

  describe ".find" do
    it "returns one record" do
      VCR.use_cassette("transfer/ach/find", record: :once) do
        transfer = client.ach_transfer "5f44f7d0-fb4d-4e16-816b-702aa24c27d0"
        expect(transfer).to be_instance_of FidorApi::Transfer::ACH
        expect_correct_transfer transfer
      end
    end
  end

end
