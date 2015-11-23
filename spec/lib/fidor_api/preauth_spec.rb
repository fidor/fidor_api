require "spec_helper"

describe FidorApi::Preauth do

  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "f859032a6ca0a4abb2be0583b8347937") }

  def expect_correct_preauth(preauth)
    expect(preauth).to be_instance_of FidorApi::Preauth
    expect(preauth.id).to                     eq 387888
    expect(preauth.account_id).to             eq "62073200"
    expect(preauth.preauth_type).to           eq "creditcard_preauth"
    expect(preauth.amount).to                 eq 7480
    expect(preauth.expires_at).to             eq Time.utc(2015, 10, 25,  0,  0,  0)
    expect(preauth.created_at).to             eq Time.utc(2015,  9, 25, 18, 29, 45)
    expect(preauth.updated_at).to             eq Time.utc(2015,  9, 25, 18, 29, 45)
    expect(preauth.currency).to               eq "EUR"

    details = preauth.preauth_type_details
    expect(details).to be_instance_of FidorApi::PreauthDetails::CreditCard
    expect(details.cc_merchant_name).to       eq "NTC Europe S A"
    expect(details.cc_merchant_category).to   eq "5499"
    expect(details.cc_type).to                eq "00"
    expect(details.cc_category).to            eq "T"
    expect(details.cc_sequence).to            eq "6882471"
    expect(details.pos_code).to               eq "812"
    expect(details.financial_network_code).to eq "MCS"
  end

  describe ".all" do
    it "returns all preauth records" do
      VCR.use_cassette("preauths/all", record: :once) do
        preauths = client.preauths
        expect(preauths).to be_instance_of FidorApi::Collection
        expect_correct_preauth(preauths.first)
      end
    end
  end

  describe ".find" do
    it "returns one record" do
      VCR.use_cassette("preauths/find", record: :once) do
        preauth = client.preauth "387888"
        expect_correct_preauth(preauth)
      end
    end
  end

end
