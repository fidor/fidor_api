require "spec_helper"

describe FidorApi::Customer do

  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "f859032a6ca0a4abb2be0583b8347937") }

  describe ".all" do
    it "returns all customer records" do
      VCR.use_cassette("customer/all", record: :once) do
        customers = client.customers
        expect(customers).to be_instance_of FidorApi::Collection

        customer = customers.first
        expect(customer).to be_instance_of FidorApi::Customer
        expect(customer.id).to                        eq 857
        expect(customer.email).to                     eq "philip_7261@fidortecs.de"
        expect(customer.first_name).to                eq "Philip"
        expect(customer.last_name).to                 eq "Müller"
        expect(customer.gender).to                    eq "m"
        expect(customer.title).to                     eq "Herr"
        expect(customer.nick).to                      be_nil
        expect(customer.maiden_name).to               be_nil
        expect(customer.adr_street).to                eq "Am"
        expect(customer.adr_street_number).to         eq "35"
        expect(customer.adr_post_code).to             eq "27204"
        expect(customer.adr_city).to                  eq "Hannover"
        expect(customer.adr_country).to               eq "DE"
        expect(customer.adr_phone).to                 eq "069-314717"
        expect(customer.adr_mobile).to                eq "0151-1363453"
        expect(customer.adr_fax).to                   eq "030-1464313"
        expect(customer.adr_businessphone).to         eq "0172-1388544"
        expect(customer.birthday).to                  eq Time.new(1995, 2, 19)
        expect(customer.is_verified).to               be true
        expect(customer.nationality).to               eq "DE"
        expect(customer.marital_status).to            eq 6
        expect(customer.religion).to                  eq 18
        expect(customer.id_card_registration_city).to eq "Frankfurt"
        expect(customer.id_card_number).to            eq "7000000446"
        expect(customer.id_card_valid_until).to       eq Time.new(2016, 9, 2)
        expect(customer.created_at).to                eq Time.new(2015, 8, 26, 15, 43, 30, "+00:00")
        expect(customer.updated_at).to                eq Time.new(2015, 8, 26, 15, 43, 30, "+00:00")
        expect(customer.creditor_identifier).to       be_nil
      end
    end
  end

  describe ".first" do
    it "returns the first customer record" do
      VCR.use_cassette("customer/first", record: :once) do
        customer = client.first_customer
        expect(customer).to be_instance_of FidorApi::Customer
      end
    end
  end

end
