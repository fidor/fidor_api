require "spec_helper"

describe FidorApi::Msisdn do

  let(:msisdn)        { "491666666666" }
  let(:affiliate_uid) { "1398b666-6666-6666-6666-666666666666" }
  let(:os_type)       { "Android" }
  let(:code_check)    { "Tm7YvR1ttXvSwWAs0t9Kz1Z6dwY6XcrKzH21gBpgyBRisIzn4R2X8DOAlqEV5Z44aXsN8A" }
  let(:code_verify)   { "Tm7YvR1ttXvSwWAs0t9Kz1Z6dwY6XcrKzH21gBpgyBRisIzn4R2X8DOAlqEV5Z44aXsN8A" }

  describe ".check" do
    it "returns a token which can be used for verification" do
      returned_code = FidorApi::Msisdn.check(msisdn: msisdn, os_type: "Android", affiliate_uid: affiliate_uid)
      expect(returned_code).to eq code_check
    end
  end

  describe ".verify" do
    it "returns a token which can be used for verification" do
      returned_code = FidorApi::Msisdn.verify(msisdn: msisdn, code: code_check)
      expect(returned_code).to eq code_verify
    end
  end

end
