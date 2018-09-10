require 'spec_helper'

RSpec.describe 'DSL - Cards' do
  let(:client)        { setup_client }
  let(:client_id)     { 'client-id' }
  let(:client_secret) { 'client-secret' }

  describe '#cards' do
    before do
      stub_fetch_request(endpoint: %r{/cards}, response_body: [{ id: 42 }, { id: 43 }])
    end

    it 'returns the current user object' do
      cards = client.cards
      expect(cards).to be_instance_of FidorApi::Collection

      card = cards.first
      expect(card).to be_instance_of FidorApi::Model::Card
      expect(card.id).to eq 42
    end
  end

  describe '#card' do
    before do
      stub_fetch_request(endpoint: %r{/cards/42}, response_body: { id: 42 })
    end

    it 'returns the current user object' do
      card = client.card 42
      expect(card).to be_instance_of FidorApi::Model::Card
      expect(card.id).to eq 42
    end
  end
end
