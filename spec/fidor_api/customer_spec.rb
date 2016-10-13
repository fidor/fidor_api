require "spec_helper"

describe FidorApi::Customer do
  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "f859032a6ca0a4abb2be0583b8347937") }

  before do
    FidorApi::Connectivity.access_token = "f859032a6ca0a4abb2be0583b8347937"
  end

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
        expect(customer.gender).to                    eq FidorApi::Customer::Gender::Male
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

  describe "#save" do
    before do
      FidorApi::Connectivity.access_token = "i_should_not_be_sent"
    end

    subject { FidorApi::Customer.new(params) }

    let(:params) do
      {
        email:                 "walther@heisenberg.com",
        password:              "superDuperSecret",
        adr_mobile:            "4917666666666",
        title:                 1, # TODO: On get it's a string like "Herr". Maybe the schema and example are wrong or the API is inconsistent in this case.
        first_name:            "Walther",
        additional_first_name: "Heisenberg",
        last_name:             "White",
        occupation:            "1",
        gender:                FidorApi::Customer::Gender::Male,
        birthplace:            "Albuquerque",
        birthday:              Date.new(1957, 9, 7),
        nationality:           "US",
        marital_status:        "1",
        adr_street:            "Negra Arroyo Lane",
        adr_street_number:     "308",
        adr_post_code:         "87111",
        adr_city:              "Albuquerque",
        adr_country:           "US",
        tos:                   true,
        privacy_policy:        true,
        own_interest:          true,
        us_citizen:            true,
        us_tax_payer:          true,
        newsletter:            true,
        verification_token:    "tE5MpiQ4AazIGFgV5cS3HFbNy6IL8Ey2IpgtUnxgzm59zDTQny4ViVjl8wpz1clRCYDQ2w"
      }
    end

    context "on a customer object which already has an id" do
      let(:params) { { id: 42 } }

      it "raises an error" do
        expect { subject.save }.to raise_error FidorApi::NoUpdatesAllowedError
      end
    end

    context "on a customer object which has no id" do
      context "on success" do
        it "returns true and sets the id on the object" do
          VCR.use_cassette("customer/create", record: :once, match_requests_on: [:method, :uri, :headers, :body]) do
            expect(subject.save).to be true
            expect(subject.id).to eq 42
          end
        end
      end

      context "on failure" do
        xit "raises an error" do
          expect { subject.save }.to raise_error FidorApi::ClientError
        end
      end
    end
  end

end
