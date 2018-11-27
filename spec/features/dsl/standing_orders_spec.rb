require 'spec_helper'

RSpec.describe 'DSL - Standing orders' do
  let(:client)                { setup_client }
  let(:client_id)             { 'client-id' }
  let(:client_secret)         { 'client-secret' }
  let(:standing_order_id)     { '92bf870d-d914-4757-8691-7f8092a77e0e' }
  let(:confirmable_action_id) { '15fcc0cb-b741-4e96-b4bf-bb5b2ce79609' }

  before do
    client.config.environment = FidorApi::Environment::Future.new
  end

  describe '#standing_order' do
    before do
      stub_fetch_request(
        endpoint:      %r{/standing_orders/#{standing_order_id}},
        response_body: { id: standing_order_id }
      )
    end

    it 'returns a standing order object' do
      standing_order = client.standing_order standing_order_id
      expect(standing_order).to be_instance_of FidorApi::Model::StandingOrder
      expect(standing_order.id).to eq standing_order_id
    end
  end

  describe '#new_standing_order' do
    let(:subject) { 'Hello World' }

    it 'returns a new instance of the standing order model' do
      standing_order = client.new_standing_order(subject: subject)
      expect(standing_order).to be_instance_of FidorApi::Model::StandingOrder
      expect(standing_order.subject).to eq subject
    end
  end

  describe '#create_standing_order' do
    let(:subject)         { 'Hello World' }
    let(:confirmable_url) { "https://api.example.com/confirmable/actions/#{confirmable_action_id}" }

    context 'when the api accepts the standing order' do
      before do
        stub_create_request(
          endpoint:         %r{/standing_orders},
          response_body:    { id: standing_order_id },
          response_headers: { 'Location' => '', 'X-Fidor-Confirmation-Path' => confirmable_url }
        )
      end

      it 'assigns the id attribute' do
        standing_order = client.create_standing_order(subject: subject)
        expect(standing_order).to be_instance_of FidorApi::Model::StandingOrder
        expect(standing_order.id).to eq standing_order_id
      end

      it 'assigns the confirmable_action_attribute' do
        standing_order = client.create_standing_order(subject: subject)
        expect(standing_order.confirmable_action_id).to eq confirmable_action_id
      end
    end

    context 'when the api rejects the transfer' do
      before do
        stub_create_request(endpoint: %r{/standing_orders}, response_body: errors, status: 422)
      end

      let(:errors) do
        {
          'status' => '422',
          'errors' => [
            { 'field' => 'base', 'message' => 'Something went wrong' },
            { 'field' => 'amount', 'key' => 'invalid' }
          ]
        }
      end

      it 'assigns the errors' do
        standing_order = client.create_standing_order(subject: subject)
        expect(standing_order).to be_instance_of FidorApi::Model::StandingOrder
        expect(standing_order.errors.full_messages).to eq [
          'Something went wrong',
          'Amount is invalid'
        ]
      end
    end
  end
end
