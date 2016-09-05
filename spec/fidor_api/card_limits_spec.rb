require "spec_helper"

describe FidorApi::CardLimits do

  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "157a51be230c2d7f186d7bb249d41d75") }

  describe ".find" do
    it "returns one card_limits record" do
      VCR.use_cassette("card_limits/find", record: :once) do
        limits = client.card_limits 7
        expect(limits.id).to                         eq 7
        expect(limits.atm_limit).to                  eq BigDecimal.new("250.0")
        expect(limits.single_limit).to               eq BigDecimal.new("1000.0")
        expect(limits.volume_limit).to               eq BigDecimal.new("1000.0")
      end
    end
  end

  describe ".change" do
    it "changes the card_limits record" do
      VCR.use_cassette("card_limits/change", record: :once) do
        expect {
          client.change_card_limits 7, {
            single_limit: BigDecimal.new("2000.0"),
            volume_limit: BigDecimal.new("2000.0"),
          }
        }.to raise_error(FidorApi::ApprovalRequired)
      end
    end
  end

end
