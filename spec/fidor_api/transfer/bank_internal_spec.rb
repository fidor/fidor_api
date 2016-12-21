require "spec_helper"

describe FidorApi::Transfer::BankInternal do
  subject do
    FidorApi::Transfer::BankInternal.new(
      account_id:              "29208706",
      external_uid:            "4279762F8",
      account_number:          "29208707",
      amount:                  BigDecimal.new("10.00"),
      currency:                "USD",
      subject:                 "Money for you"
    )
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :account_id       }
    it { is_expected.to validate_presence_of :external_uid     }
    it { is_expected.to validate_presence_of :account_number   }
    it { is_expected.to validate_presence_of :amount           }
    it { is_expected.to validate_presence_of :subject          }
  end

  describe "#save" do
    context "on invalid object" do
      it "raises an error" do
        subject.account_id = nil

        expect { subject.save }.to raise_error FidorApi::InvalidRecordError
      end
    end
  end

  describe "#as_json" do
    it "returns all writeable fields" do
      expect(subject.as_json).to eq(
        account_id: "29208706",
        amount: 1000,
        beneficiary: {
          unique_name: nil,
          contact: {},
          bank: {},
          routing_type: "BANK_INTERNAL",
          routing_info: {
            account_number: "29208707"
          }
        },
        currency: "USD",
        external_uid: "4279762F8",
        subject: "Money for you"
      )
    end
  end
end
