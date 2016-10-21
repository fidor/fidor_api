require "spec_helper"

describe FidorApi::Customers::Confirmations do
  describe "#create" do
    before { FidorApi::Connectivity.access_token = 'c3721bace3cfc8f2e88fcc086a464f34' }

    it "creates OTP for msisdn activation" do
      VCR.use_cassette("customers/confirmations", record: :once) do
        expect { described_class.create }.to raise_error(FidorApi::ApprovalRequired)
      end
    end
  end
end
