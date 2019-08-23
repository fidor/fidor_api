require 'spec_helper'

RSpec.describe 'DSL - Standing orders' do
  let(:client)                { setup_client }
  let(:client_id)             { 'client-id' }
  let(:client_secret)         { 'client-secret' }
  let(:standing_order_id)     { '92bf870d-d914-4757-8691-7f8092a77e0e' }
  let(:confirmable_action_id) { '15fcc0cb-b741-4e96-b4bf-bb5b2ce79609' }
  let(:request_headers) do
    { 'X-Something' => '42' }
  end

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

  describe '#standing_orders' do
    let(:beneficiary) do
      {
        'unique_name':  'string',
        'contact':      {
          'name': 'Shreyas Agarwal'
        },
        'bank':         {
          'name':           'Maze Bank',
          'address_line_1': 'Main Street 1',
          'address_line_2': 'House 2',
          'city':           'New York',
          'country':        'USA'
        },
        'routing_type': 'SEPA',
        'routing_info': {}
      }
    end
    let(:schedule) do
      {
        'rhythm':               'weekly',
        'runtime_day_of_month': 1,
        'runtime_day_of_week':  'Mon',
        'start_date':           '2019-06-03',
        'ultimate_run':         '2019-06-03'
      }
    end

    before do
      stub_fetch_request(
        endpoint:      %r{/standing_orders},
        response_body: [
          {
            'id':                    'c51038a3-8ace-4e56-9009-72a5d319b66b',
            'account_id':            '12345678',
            'external_uid':          '4279762F8',
            'amount':                4223,
            'currency':              'EUR',
            'subject':               'Money for you',
            'status':                'created',
            'additional_attributes': {},
            'beneficiary':           beneficiary,
            'schedule':              schedule
          }
        ]
      )
    end

    it 'returns all the requested standing orders objects' do
      standing_order = client.standing_orders.first
      expect(standing_order).to be_instance_of FidorApi::Model::StandingOrder
      expect(standing_order.id).to eq 'c51038a3-8ace-4e56-9009-72a5d319b66b'
      expect(standing_order.contact_name).to eq 'Shreyas Agarwal'
      expect(standing_order.routing_type).to eq 'SEPA'
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

  describe '#confirm_standing_order' do
    before do
      stub_update_request(
        endpoint:         %r{/standing_orders/92bf870d-d914-4757-8691-7f8092a77e0e/confirm},
        request_headers:  request_headers,
        response_body:    {
          id:    'eb5e8e0d-4611-4124-a1c5-f0b1afad250b',
          links: { redirect: redirect_link }
        },
        response_headers: { 'Location' => location },
        status:           303
      )
    end

    let(:location) { 'https://api.example.com/confirm/eb5e8e0d-4611-4124-a1c5-f0b1afad250b' }
    let(:redirect_link) { 'https://auth.example.com/confirmable/eb5e8e0d-4611-4124-a1c5-f0b1afad250b' }

    it 'returns the confirmation response' do
      return_value = client.confirm_standing_order('92bf870d-d914-4757-8691-7f8092a77e0e', headers: request_headers)
      expect(return_value.headers['Location']).to eq location
      expect(return_value.body['links']['redirect']).to eq redirect_link
    end
  end

  describe '#update_standing_order' do
    let(:subject) { 'Hello World' }

    context 'when the api accepts the Standing Order' do
      before do
        stub_update_request(
          endpoint:        %r{/standing_orders/#{standing_order_id}},
          request_headers: request_headers,
          response_body:   { id: standing_order_id }
        )
      end

      it 'returns the updated object' do
        transfer = client.update_standing_order(standing_order_id, { subject: subject }, headers: request_headers)
        expect(transfer).to be_instance_of FidorApi::Model::StandingOrder
        expect(transfer.subject).to eq subject
      end
    end
  end

  describe '#delete_standing_order' do
    before do
      stub_delete_request(
        endpoint:         %r{/standing_orders/#{standing_order_id}},
        request_headers:  request_headers,
        response_body:    {
          id:    'eb5e8e0d-4611-4124-a1c5-f0b1afad250b',
          links: { redirect: redirect_link }
        },
        response_headers: { 'Location' => location },
        status:           303
      )
    end

    let(:location) { 'https://api.example.com/confirm/actions/cc5f8b43-f28f-4aa6-8717-2c9a77557a91' }
    let(:redirect_link) { 'https://api.example.com/confirm/actions/cc5f8b43-f28f-4aa6-8717-2c9a77557a91' }

    it 'returns the confirmation response' do
      return_value = client.delete_standing_order('92bf870d-d914-4757-8691-7f8092a77e0e', headers: request_headers)
      expect(return_value.headers['Location']).to eq location
      expect(return_value.body['links']['redirect']).to eq redirect_link
    end
  end
end
