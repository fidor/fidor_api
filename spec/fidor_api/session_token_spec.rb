require "spec_helper"

describe FidorApi::SessionToken do

  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "f859032a6ca0a4abb2be0583b8347937") }

  describe ".create" do
    it "returns an instance" do
      VCR.use_cassette("session_tokens/create", record: :once) do
        record = client.create_session_token

        expect(record.token).to eq "8d10db0148cd7c573b20d2e56df867841a6d98b0"
      end
    end
  end

end
