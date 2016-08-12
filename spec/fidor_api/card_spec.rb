require "spec_helper"

describe FidorApi::Card do

  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "f859032a6ca0a4abb2be0583b8347937") }

  def expect_correct_card(card)
    expect(card).to be_instance_of FidorApi::Card
    expect(card.id).to                         eq 42
    expect(card.account_id).to                 eq "875"
    expect(card.inscription).to                eq "Philipp Müller"
    expect(card.type).to                       eq "fidor_debit_master_card"
    expect(card.design).to                     eq "debit-card"
    expect(card.currency).to                   eq "EUR"
    expect(card.physical).to                   be true
    expect(card.balance).to                    eq 0
    expect(card.atm_limit).to                  eq BigDecimal.new("1000.0")
    expect(card.transaction_single_limit).to   eq BigDecimal.new("2000.0")
    expect(card.transaction_volume_limit).to   eq BigDecimal.new("3000.0")
    expect(card.email_notification).to         be true
    expect(card.sms_notification).to           eq false
    expect(card.payed).to                      be true
    expect(card.state).to                      eq "card_registration_completed"
    expect(card.lock_reason).to                be_nil
    expect(card.disabled).to                   be true
    expect(card.created_at).to                 eq DateTime.new(2015, 11, 3, 11,  7, 25)
    expect(card.updated_at).to                 eq DateTime.new(2015, 11, 9, 10, 55,  6)
  end

  describe ".all" do
    it "returns all card records" do
      VCR.use_cassette("card/all", record: :once) do
        cards = client.cards
        expect(cards).to be_instance_of FidorApi::Collection
        expect_correct_card(cards.first)
      end
    end
  end

  describe ".find" do
    it "returns one card record" do
      VCR.use_cassette("card/find", record: :once) do
        card = client.card 42
        expect_correct_card(card)
      end
    end
  end

  describe ".activate" do
    it "asks for confirmation" do
      VCR.use_cassette("card/activate", record: :once) do
        card = client.card 8
        expect(card.state).to eq 'card_registration_completed'

        expect { client.activate_card(8) }.to raise_error(FidorApi::ApprovalRequired)
      end
    end
  end

  describe ".lock" do
    it "locks the card" do
      VCR.use_cassette("card/lock", record: :once) do
        card = client.card 42
        expect(card.disabled).to be false

        expect(client.lock_card(42)).to be true

        card = client.card 42
        expect(card.disabled).to be true
      end
    end
  end

  describe ".unlock" do
    it "unlocks the card" do
      VCR.use_cassette("card/unlock", record: :once) do
        card = client.card 42
        expect(card.disabled).to be true

        expect(client.unlock_card(42)).to be true

        card = client.card 42
        expect(card.disabled).to be false
      end
    end
  end

  describe ".cancel" do
    it "asks for confirmation" do
      VCR.use_cassette("card/cancel", record: :once) do
        card = client.card 8
        expect(card.state).to eq 'active'

        expect { client.cancel_card(8) }.to raise_error(FidorApi::ApprovalRequired)
      end
    end
  end

  describe "#save" do
    it "creates a card object and sets it's data" do
      VCR.use_cassette("card/save_success", record: :once) do
        card = client.build_card(
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
end
