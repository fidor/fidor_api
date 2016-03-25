require "spec_helper"

describe FidorApi::CardLimits do

  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "f859032a6ca0a4abb2be0583b8347937") }

  describe ".find" do
    it "returns one card_limits record" do
      VCR.use_cassette("card_limits/find", record: :once) do
        limits = client.card_limits 42
        expect(limits.atm_limit).to                  eq BigDecimal.new("1000.0")
        expect(limits.transaction_single_limit).to   eq BigDecimal.new("1000.0")
        expect(limits.transaction_volume_limit).to   eq BigDecimal.new("1000.0")
      end
    end
  end

  describe ".change" do
    it "changes the card_limits record" do
      VCR.use_cassette("card_limits/change", record: :once) do
        limits = client.change_card_limits 42, {
          transaction_single_limit: BigDecimal.new("2000.0"),
          transaction_volume_limit: BigDecimal.new("2000.0"),
        }

        expect(limits.atm_limit).to                  eq BigDecimal.new("1000.0")
        expect(limits.transaction_single_limit).to   eq BigDecimal.new("2000.0")
        expect(limits.transaction_volume_limit).to   eq BigDecimal.new("2000.0")
      end
    end
  end

end
