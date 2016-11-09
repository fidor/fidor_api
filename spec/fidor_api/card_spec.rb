require "spec_helper"

describe FidorApi::Card do
  before do
    FidorApi::Connectivity.access_token = 'f859032a6ca0a4abb2be0583b8347937'
  end

  def expect_correct_card(card)
    expect(card).to be_instance_of FidorApi::Card
    expect(card.id).to                 eq 42
    expect(card.account_id).to         eq "875"
    expect(card.inscription).to        eq "Philipp Müller"
    expect(card.type).to               eq "fidor_debit_master_card"
    expect(card.design).to             eq "debit-card"
    expect(card.currency).to           eq "EUR"
    expect(card.physical).to           be true
    expect(card.balance).to            eq 0
    expect(card.atm_limit).to          eq 100_000
    expect(card.single_limit).to       eq 200_000
    expect(card.volume_limit).to       eq 300_000
    expect(card.email_notification).to be true
    expect(card.sms_notification).to   eq false
    expect(card.payed).to              be true
    expect(card.state).to              eq "card_registration_completed"
    expect(card.lock_reason).to        be_nil
    expect(card.disabled).to           be true
    expect(card.created_at).to         eq DateTime.new(2015, 11, 3, 11,  7, 25)
    expect(card.updated_at).to         eq DateTime.new(2015, 11, 9, 10, 55,  6)
  end

  describe ".all" do
    it "returns all card records" do
      VCR.use_cassette("card/all", record: :once) do
        cards = FidorApi::Card.all
        expect(cards).to be_instance_of FidorApi::Collection
        expect_correct_card(cards.first)
      end
    end
  end

  describe ".find" do
    it "returns one card record" do
      VCR.use_cassette("card/find", record: :once) do
        card = FidorApi::Card.find 42
        expect_correct_card(card)
      end
    end
  end

  describe '#activate' do
    it "asks for confirmation" do
      VCR.use_cassette("card/activate", record: :once) do
        card = FidorApi::Card.find 8
        expect(card.state).to eq 'card_registration_completed'
        expect { card.activate }.to raise_error(FidorApi::ApprovalRequired)
      end
    end
  end

  describe "#lock" do
    it "locks the card" do
      VCR.use_cassette("card/lock", record: :once) do
        card = FidorApi::Card.find 42
        expect(card.disabled).to be false

        expect(card.lock).to be true

        card.reload
        expect(card.disabled).to be true
      end
    end
  end

  describe "#unlock" do
    it "unlocks the card" do
      VCR.use_cassette("card/unlock", record: :once) do
        card = FidorApi::Card.find 42
        expect(card.disabled).to be true

        expect(card.unlock).to be true

        card.reload
        expect(card.disabled).to be false
      end
    end
  end

  describe ".cancel" do
    let(:card) { FidorApi::Card.new(id: 123) }

    it "uses the stolen reason" do
      stub = stub_request(:put, "https://aps.fidor.de/cards/123/block")
      card.cancel(reason: 'stolen')
      expect(stub).to have_been_requested
    end

    it "asks for confirmation" do
      VCR.use_cassette("card/cancel", record: :once) do
        card = FidorApi::Card.find 8
        expect(card.state).to eq 'active'

        expect { card.cancel }.to raise_error(FidorApi::ApprovalRequired)
      end
    end
  end

  describe "#save" do
    it "creates a card object and sets it's data" do
      VCR.use_cassette("card/save_success", record: :once) do
        card = FidorApi::Card.new(
          account_id: "875",
          type:       "fidor_debit_master_card",
          pin:        "4711"
        )

        expect(card.save).to be true

        expect(card.id).to          eq 43
        expect(card.account_id).to  eq "875"
        expect(card.inscription).to eq "Philipp Müller"
        expect(card.type).to        eq "fidor_debit_master_card"
        expect(card.state).to       eq "card_registration_pending"
      end
    end
  end

  describe "address" do
    it "supports shorthands" do
      card = described_class.new(address_name: 'Hans')
      expect(card.address_name).to eq('Hans')
      expect(card.address['name']).to eq('Hans')
    end
  end

  describe "limit methods" do
    it "creates them dynamically" do
      card = described_class.new(limits: {'something' => 10000})
      expect(card.something_limit).to eq(10000)
    end
  end
end
