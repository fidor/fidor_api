require "spec_helper"

describe FidorApi::Transfer::Swift do

  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "0816d2665999fbd76a69c6f0050a49fa") }

  before do
    FidorApi::Connectivity.access_token = token.access_token
  end

  subject do
    FidorApi::Transfer::Swift.new(
      account_id:              "29208706",
      external_uid:            "4279762F8",
      beneficiary_unique_name: "Johnny Doe",
      contact_name:            "John Doe",
      contact_address_line_1:  "Street 123",
      bank_name:               "Bank Name",
      bank_address_line_1:     "Street 456",
      account_number:          "DE08100100100666666666",
      swift_code:              "FDDODEMMXXX",
      account_currency:        "EUR",
      amount:                  BigDecimal.new("10.00"),
      currency:                "USD",
      subject:                 "Money for you"
    )
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :account_id       }
    it { is_expected.to validate_presence_of :external_uid     }
    it { is_expected.to validate_presence_of :contact_name     }
    it { is_expected.to validate_presence_of :account_number   }
    it { is_expected.to validate_presence_of :swift_code       }
    it { is_expected.to validate_presence_of :account_currency }
    it { is_expected.to validate_presence_of :amount           }
    it { is_expected.to validate_presence_of :subject          }
  end

  describe "#save" do
    context "on success" do
      it "returns true and updates the attributes with received data" do
        VCR.use_cassette("transfer/swift/save_success", record: :once) do
          expect(subject.save).to be true

          expect(subject.id).to be_nil
          expect(subject.exchange_rate).to eq "0.9713704206"
          expect(subject.needs_confirmation?).to be true

          action = subject.confirmable_action

          expect(action).to be_a FidorApi::ConfirmableAction
          expect(action.id).to eq "8437c0c7-f704-4fc8-8ee0-3c18aedc8484"
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

        VCR.use_cassette("transfer/swift/save_failure", record: :once) do
          expect(subject.save).to be false
          expect(subject.errors[:account_id]).to eq ["should be the token user's account id"]
          expect(subject.errors[:account_number]).to eq ["is_invalid"]
          expect(subject.errors.details).to eq(
            account_id:     [{error: "should be the token user's account id"}],
            account_number: [{error: :invalid}]
          )
        end
      end
    end
  end

  describe "#as_json" do
    it "returns all writeable fields" do
      expect(subject.as_json).to eq(
        account_id: "29208706",
        amount: 1000,
        beneficiary: {
          unique_name: "Johnny Doe",
          contact: {
            name:           "John Doe",
            address_line_1: "Street 123"
          },
          bank: {
            name:           "Bank Name",
            address_line_1: "Street 456"

          },
          routing_type: "SWIFT",
          routing_info: {
            account_number:   "DE08100100100666666666",
            swift_code:       "FDDODEMMXXX",
            account_currency: "EUR"
          }
        },
        currency: "USD",
        external_uid: "4279762F8",
        subject: "Money for you"
      )
    end
  end

end
