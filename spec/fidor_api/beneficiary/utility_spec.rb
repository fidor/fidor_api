require "spec_helper"

describe FidorApi::Beneficiary::Utility do
  let(:token)  { FidorApi::Token.new(access_token: "73570bdde25a22bc7219acd1d43a1cde") }
  let(:client) { FidorApi::Client.new(token: token) }
  let(:beneficiary_id) { "711e1549-cbb3-4018-913b-13d90530184e" }

  subject do
    described_class.new(params)
  end

  before do
    FidorApi::Connectivity.access_token = "f859032a6ca0a4abb2be0583b8347937"
  end

  context "when complete data is given" do
    let(:params) do
      {
        "account_id"                => "91318832",
        "unique_name"               => "joey_doey",
        "routing_type"              => "UTILITY",
        "routing_info" => {
          "utility_provider"        => "Utility Provider",
          "utility_service"         => "Utility Service",
          "utility_service_number"  => "12345678"
        }
      }
    end

    describe "#save" do
      it "creates a beneficiary object and sets it's data" do
        VCR.use_cassette("beneficiary/utility/save_success", record: :once) do
          expect(subject.save).to be_truthy

          expect(subject).to be_instance_of FidorApi::Beneficiary::Utility

          expect(subject.id).to                      eq beneficiary_id
          expect(subject.account_id).to              eq "91318832"
          expect(subject.utility_provider).to        eq "Utility Provider"
          expect(subject.utility_service).to         eq "Utility Service"
          expect(subject.utility_service_number).to  eq "12345678"
        end
      end
    end
  end

  context "with missing data" do
    let(:params) do
      {"account_id" => ""}
    end

    describe "#save" do
      it "returns error" do
        expect{ subject.save }.to raise_error FidorApi::InvalidRecordError
      end
    end
  end
end
