require 'spec_helper'

RSpec.describe 'DSL - Cards' do
  let(:client)        { setup_client }
  let(:client_id)     { 'client-id' }
  let(:client_secret) { 'client-secret' }
  let(:card_type)     { 'credit_card' }

  describe '#cards' do
    before do
      stub_fetch_request(endpoint: %r{/cards}, response_body: [{ id: 42 }, { id: 43 }])
    end

    it 'returns a collection of cards' do
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

    it 'returns the card object' do
      card = client.card 42
      expect(card).to be_instance_of FidorApi::Model::Card
      expect(card.id).to eq 42
    end
  end

  describe '#create_card' do
    context 'when the api accepts the card' do
      before do
        stub_create_request(endpoint: %r{/cards}, response_body: { id: 42 })
      end

      it 'assigns the attributes' do
        card = client.create_card(type: card_type)
        expect(card).to be_instance_of FidorApi::Model::Card
        expect(card.id).to eq 42
      end
    end

    context 'when the api rejects the card' do
      before do
        stub_create_request(endpoint: %r{/cards}, response_body: errors, status: 422)
      end

      let(:errors) do
        {
          'status' => '422',
          'errors' => [
            { 'field' => 'base', 'message' => 'Something went wrong' }
          ]
        }
      end

      it 'assigns the errors' do
        card = client.create_card(type: card_type)
        expect(card).to be_instance_of FidorApi::Model::Card
        expect(card.errors.full_messages).to eq [
          'Something went wrong'
        ]
      end
    end
  end
end
