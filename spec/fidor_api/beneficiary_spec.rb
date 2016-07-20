require "spec_helper"

describe FidorApi::Beneficiary do

  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "f859032a6ca0a4abb2be0583b8347937") }

  def expect_correct_beneficiary(beneficiary)
    expect(beneficiary).to be_instance_of FidorApi::Beneficiary
    expect(beneficiary.id).to                     eq "6422ec33-4935-41cc-af26-6af40c4c1349"
    expect(beneficiary.account_id).to             eq "56827782"
    expect(beneficiary.contact_name).to           eq "John Doe"
    expect(beneficiary.contact_address_line_1).to eq "Contact Address 1"
    expect(beneficiary.contact_address_line_2).to eq "Contact Address 2"
    expect(beneficiary.contact_city).to           eq "Contact City"
    expect(beneficiary.contact_country).to        eq "Contact Country"
    expect(beneficiary.bank_name).to              eq "Bank Name"
    expect(beneficiary.bank_address_line_1).to    eq "Bank Address 1"
    expect(beneficiary.bank_address_line_2).to    eq "Bank Address 2"
    expect(beneficiary.bank_city).to              eq "Bank City"
    expect(beneficiary.bank_country).to           eq "Bank Country"
    expect(beneficiary.routing_type).to           eq "ACH"
    expect(beneficiary.routing_info).to           be_a Hash
    expect(beneficiary.verified).to               be true

    expect(beneficiary.routing_info["account_number"]).to eq "John Doe"
    expect(beneficiary.routing_info["routing_code"]).to   eq "123456"
  end

  describe ".all" do
    it "returns all beneficiary records" do
      VCR.use_cassette("beneficiary/all", record: :once) do
        beneficiaries = client.beneficiaries
        expect(beneficiaries).to be_instance_of FidorApi::Collection
        expect_correct_beneficiary beneficiaries.first
      end
    end
  end

  describe ".find" do
    it "returns one record" do
      VCR.use_cassette("beneficiary/find", record: :once) do
        beneficiary = client.beneficiary "6422ec33-4935-41cc-af26-6af40c4c1349"
        expect_correct_beneficiary beneficiary
      end
    end
  end

end
