require "spec_helper"

describe FidorApi::Transfer::P2pAccountNumber do

  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "0816d2665999fbd76a69c6f0050a49fa") }

  subject do
    client.build_p2p_account_number_transfer(
      account_id:              "29208706",
      external_uid:            "4279762F8",
      beneficiary_unique_name: "Johnny Doe",
      account_number:          "1234567",
      amount:                  BigDecimal.new("10.00"),
      currency:                "USD",
      subject:                 "Money for you"
    )
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :account_id          }
    it { is_expected.to validate_presence_of :external_uid        }
    it { is_expected.to validate_presence_of :account_number      }
    it { is_expected.to validate_presence_of :amount              }
    it { is_expected.to validate_presence_of :subject             }
    it { is_expected.to_not validate_presence_of :contact_name    }
  end

  describe "#save" do
    context "on success" do
      it "returns true and updates the attributes with received data" do
        VCR.use_cassette("transfer/p2p_account_number/save_success", record: :once) do
          expect(subject.save).to be true

          expect(subject.id).to be_nil
          expect(subject.needs_confirmation?).to be true

          action = subject.confirmable_action

          expect(action).to be_a FidorApi::ConfirmableAction
          expect(action.id).to eq "8437c0c7-f704-4fc8-8ee0-3c18aedc8484"
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
          contact: {},
          bank: {},
          routing_type: "FOS_P2P_ACCOUNT_NUMBER",
          routing_info: {
            account_number: "1234567"
          }
        },
        currency: "USD",
        external_uid: "4279762F8",
        subject: "Money for you"
      )
    end
  end

end
