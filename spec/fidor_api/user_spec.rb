require "spec_helper"

describe FidorApi::User do

  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "f859032a6ca0a4abb2be0583b8347937") }

  describe ".current" do
    it "returns information about the current user" do
      VCR.use_cassette("user/current", record: :once) do
        user = client.current_user

        expect(user).to be_instance_of FidorApi::User
        expect(user.id).to                  eq 857
        expect(user.email).to               eq "api_tester@example.com"
        expect(user.msisdn_activated_at).to eq Time.new(2015, 8, 26, 15, 43, 30, "+00:00")
        expect(user.last_sign_in_at).to     be_nil
        expect(user.created_at).to          eq Time.new(2015, 8, 26, 15, 43, 30, "+00:00")
        expect(user.updated_at).to          eq Time.new(2015, 8, 26, 15, 43, 30, "+00:00")
      end
    end
  end

end
