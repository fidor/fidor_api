require "spec_helper"

describe FidorApi::Transfer::Utility do

  let(:token)  { FidorApi::Token.new(access_token: "0816d2665999fbd76a69c6f0050a49fa") }
  let(:client) { FidorApi::Client.new(token: token) }
  let(:params) do
    {
      account_id:              "29208706",
      external_uid:            "4279762D9",
      beneficiary_unique_name: "Johnny Doey",
      utility_provider:        "Utility Provider",
      utility_service:         "Utility Service",
      utility_service_number:  "12345678",
      inquiry_ref_num:         "534Z2qoa1qig46d4",
      amount:                  BigDecimal.new("10.00"),
      currency:                "USD",
      subject:                 "Money for you"
    }
  end

  subject do
    described_class.new(params)
  end

  before do
    FidorApi::Connectivity.access_token = "0816d2665999fbd76a69c6f0050a49fa"
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :account_id             }
    it { is_expected.to validate_presence_of :external_uid           }
    it { is_expected.to validate_presence_of :utility_provider       }
    it { is_expected.to validate_presence_of :utility_service        }
    it { is_expected.to validate_presence_of :utility_service_number }
    it { is_expected.to validate_presence_of :inquiry_ref_num        }
    it { is_expected.to validate_presence_of :amount                 }
    it { is_expected.to validate_presence_of :subject                }
  end

  describe "#save" do
    context "on success" do
      it "returns true and updates the attributes with received data" do
        VCR.use_cassette("transfer/utility/save_success", record: :once) do
          expect(subject.save).to be true

          expect(subject.id).not_to be_nil
          expect(subject.needs_confirmation?).to be true

          action = subject.confirmable_action

          expect(action).to be_a FidorApi::ConfirmableAction
          expect(action.id).to eq "13a414ce-1560-43e7-870f-c43829b9d589"
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
        subject.account_id =  999

        VCR.use_cassette("transfer/utility/save_failure", record: :once) do
          expect(subject.save).to be false
          expect(subject.errors[:account_id]).to eq ["should be the token user's account id"]
          expect(subject.errors.details).to eq(
            account_id:     [{error: "should be the token user's account id"}],
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
          unique_name: "Johnny Doey",
          contact: {},
          bank: {},
          routing_type: "UTILITY",
          routing_info: {
            utility_provider:       "Utility Provider",
            utility_service:        "Utility Service",
            utility_service_number: "12345678",
            inquiry_ref_num:        "534Z2qoa1qig46d4"
          }
        },
        currency: "USD",
        external_uid: "4279762D9",
        subject: "Money for you"
      )
    end
  end

end
