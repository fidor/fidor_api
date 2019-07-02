require 'spec_helper'

RSpec.describe 'DSL - Scheduled Transfer' do
  let(:client)                { setup_client }
  let(:client_id)             { 'client-id' }
  let(:client_secret)         { 'client-secret' }
  let(:scheduled_transfer_id) { '92bf870d-d914-4757-4366-7f8092aaj1aa' }
  let(:confirmable_action_id) { '15fcc0cb-b741-4e96-b4bf-bb5b2ce79609' }
  let(:request_headers) do
    { 'X-Something' => '42' }
  end

  before do
    client.config.environment = FidorApi::Environment::Future.new
  end

  describe '#scheduled_transfer' do
    before do
      stub_fetch_request(
        endpoint:      %r{/scheduled_transfers/#{scheduled_transfer_id}},
        response_body: { id: scheduled_transfer_id }
      )
    end

    it 'returns a standing order object' do
      scheduled_transfer = client.scheduled_transfer scheduled_transfer_id
      expect(scheduled_transfer).to be_instance_of FidorApi::Model::ScheduledTransfer
      expect(scheduled_transfer.id).to eq scheduled_transfer_id
    end
  end

  describe '#scheduled_transfers' do
    let(:beneficiary) do
      {
        'unique_name':  'string',
        'contact':      {
          'name': 'Shreyas Agarwal'
        },
        'bank':         {},
        'routing_type': 'SEPA',
        'routing_info': {}
      }
    end

    before do
      stub_fetch_request(
        endpoint:      %r{/scheduled_transfers},
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
            'scheduled_date':        '2118-05-23'
          }
        ]
      )
    end

    it 'returns all the requested scheduled transfers objects' do
      scheduled_transfer = client.scheduled_transfers.first
      expect(scheduled_transfer).to be_instance_of FidorApi::Model::ScheduledTransfer
      expect(scheduled_transfer.id).to eq 'c51038a3-8ace-4e56-9009-72a5d319b66b'
      expect(scheduled_transfer.contact_name).to eq 'Shreyas Agarwal'
      expect(scheduled_transfer.routing_type).to eq 'SEPA'
    end
  end

  describe '#new_scheduled_transfer' do
    let(:subject) { 'Hello World' }

    it 'returns a new instance of the standing order model' do
      scheduled_transfer = client.new_scheduled_transfer(subject: subject)
      expect(scheduled_transfer).to be_instance_of FidorApi::Model::ScheduledTransfer
      expect(scheduled_transfer.subject).to eq subject
    end
  end

  describe '#create_scheduled_transfer' do
    let(:subject)         { 'Hello World' }
    let(:confirmable_url) { "https://api.example.com/confirmable/actions/#{confirmable_action_id}" }

    context 'when the api accepts the standing order' do
      before do
        stub_create_request(
          endpoint:         %r{/scheduled_transfers},
          response_body:    { id: scheduled_transfer_id },
          response_headers: { 'Location' => '', 'X-Fidor-Confirmation-Path' => confirmable_url }
        )
      end

      it 'assigns the id attribute' do
        scheduled_transfer = client.create_scheduled_transfer(subject: subject)
        expect(scheduled_transfer).to be_instance_of FidorApi::Model::ScheduledTransfer
        expect(scheduled_transfer.id).to eq scheduled_transfer_id
      end

      it 'assigns the confirmable_action_attribute' do
        scheduled_transfer = client.create_scheduled_transfer(subject: subject)
        expect(scheduled_transfer.confirmable_action_id).to eq confirmable_action_id
      end
    end

    context 'when the api rejects the transfer' do
      before do
        stub_create_request(endpoint: %r{/scheduled_transfers}, response_body: errors, status: 422)
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
        scheduled_transfer = client.create_scheduled_transfer(subject: subject)
        expect(scheduled_transfer).to be_instance_of FidorApi::Model::ScheduledTransfer
        expect(scheduled_transfer.errors.full_messages).to eq [
          'Something went wrong',
          'Amount is invalid'
        ]
      end
    end
  end

  describe '#confirm_scheduled_transfer' do
    before do
      stub_update_request(
        endpoint:         %r{/scheduled_transfers/92bf870d-d914-4757-8691-7f8092a77e0e/confirm},
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
      return_value = client.confirm_scheduled_transfer('92bf870d-d914-4757-8691-7f8092a77e0e', headers: request_headers)
      expect(return_value.headers['Location']).to eq location
      expect(return_value.body['links']['redirect']).to eq redirect_link
    end
  end

  describe '#update_scheduled_transfer' do
    let(:subject) { 'Hello World' }

    context 'when the api accepts the Standing Order' do
      before do
        stub_update_request(
          endpoint:        %r{/scheduled_transfers/#{scheduled_transfer_id}},
          request_headers: request_headers,
          response_body:   { id: scheduled_transfer_id }
        )
      end

      it 'returns the updated object' do
        transfer = client.update_scheduled_transfer(scheduled_transfer_id, { subject: subject }, headers: request_headers)
        expect(transfer).to be_instance_of FidorApi::Model::ScheduledTransfer
        expect(transfer.subject).to eq subject
      end
    end
  end
end
