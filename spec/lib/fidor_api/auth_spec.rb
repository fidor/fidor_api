require "spec_helper"

describe FidorApi::Auth do

  describe ".authorize_url" do
    it "returns the url to initialize the oAuth process" do
      expect(FidorApi::Auth.authorize_url).to eq "https://aps.fidor.de/oauth/authorize?client_id=client-id&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauth%2Fcallback&state=empty&response_type=code"
    end
  end

  describe ".fetch_token" do
    let(:code) { "1df62e9615dba299bdcf4057252287f9" }

    it "receives the access_token from the token endpoint" do
      VCR.use_cassette("auth/fetch_token", record: :once) do
        token = FidorApi::Auth.fetch_token code
        expect(token).to be_instance_of FidorApi::Token
        expect(token.access_token).to  eq "f859032a6ca0a4abb2be0583b8347937"
        expect(token.expires_at).to    be_instance_of Time
        expect(token.token_type).to    eq "bearer"
        expect(token.refresh_token).to eq "R2e56842abdff9fd0773ddf0f5703c075"
      end
    end
  end

  describe ".refresh_token" do
    it "receives a new access_token for a refresh_token" do
      VCR.use_cassette("auth/refresh_token", record: :once) do
        token = instance_double("FidorApi::Token", refresh_token: "R9402955f445c146eaa89db8207ae2138")

        token = FidorApi::Auth.refresh_token token
        expect(token).to be_instance_of FidorApi::Token
        expect(token.access_token).to  eq "053e49b190b005e0ca9afcb4991dffcb"
        expect(token.expires_at).to    be_instance_of Time
        expect(token.token_type).to    eq "bearer"
        expect(token.refresh_token).to eq "Rbf9d9e76cd9f61e0ac6cb63f39ea3831"
      end
    end
  end

end
