require 'spec_helper'

RSpec.describe 'DSL - Transfers - Generic' do
  let(:client)        { setup_client }
  let(:client_id)     { 'client-id' }
  let(:client_secret) { 'client-secret' }

  let(:request_headers) do
    { 'X-Something' => '42' }
  end

  before do
    client.config.environment = FidorApi::Environment::Future.new
  end

  describe '#transfers' do
    before do
      stub_fetch_request(
        endpoint:      %r{/transfers},
        response_body: [
          { id: '92bf870d-d914-4757-8691-7f8092a77e0e' },
          { id: 'ff5ac034-6cd1-4740-b582-dada99ed0257' }
        ]
      )
    end

    it 'returns an array of internal-transfer objects' do
      transfers = client.transfers
      expect(transfers).to be_instance_of FidorApi::Collection

      transfer = transfers.first
      expect(transfer).to be_instance_of FidorApi::Model::Transfer::Generic
      expect(transfer.id).to eq '92bf870d-d914-4757-8691-7f8092a77e0e'
    end
  end

  describe '#transfer' do
    before do
      stub_fetch_request(
        endpoint:      %r{/transfers/92bf870d-d914-4757-8691-7f8092a77e0e},
        response_body: { id: '92bf870d-d914-4757-8691-7f8092a77e0e' }
      )
    end

    it 'returns an array of internal-transfer objects' do
      transfer = client.transfer '92bf870d-d914-4757-8691-7f8092a77e0e'
      expect(transfer).to be_instance_of FidorApi::Model::Transfer::Generic
      expect(transfer.id).to eq '92bf870d-d914-4757-8691-7f8092a77e0e'
    end
  end

  describe '#new_transfer' do
    let(:subject) { 'Hello World' }

    it 'returns a new instance of the internal-transfer model' do
      transfer = client.new_transfer(subject: subject)
      expect(transfer).to be_instance_of FidorApi::Model::Transfer::Generic
      expect(transfer.subject).to eq subject
    end
  end

  describe '#create_transfer' do
    let(:subject)         { 'Hello World' }
    let(:confirmable_url) { 'https://api.example.com/confirmable/actions/15fcc0cb-b741-4e96-b4bf-bb5b2ce79609' }

    context 'when the api accepts the transfer' do
      before do
        stub_create_request(
          endpoint:         %r{/transfers},
          request_headers:  request_headers,
          response_body:    { id: '92bf870d-d914-4757-8691-7f8092a77e0e' },
          response_headers: { 'Location' => '', 'X-Fidor-Confirmation-Path' => confirmable_url }
        )
      end

      it 'assigns the id attribute' do
        transfer = client.create_transfer({ subject: subject }, headers: request_headers)
        expect(transfer).to be_instance_of FidorApi::Model::Transfer::Generic
        expect(transfer.id).to eq '92bf870d-d914-4757-8691-7f8092a77e0e'
      end

      it 'assigns the confirmable_action_attribute' do
        transfer = client.create_transfer({ subject: subject }, headers: request_headers)
        expect(transfer.confirmable_action_id).to eq '15fcc0cb-b741-4e96-b4bf-bb5b2ce79609'
      end
    end

    context 'when the api rejects the transfer' do
      before do
        stub_create_request(endpoint: %r{/transfers}, response_body: errors, status: 422)
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
        transfer = client.create_transfer(subject: subject)
        expect(transfer).to be_instance_of FidorApi::Model::Transfer::Generic
        expect(transfer.errors.full_messages).to eq [
          'Something went wrong',
          'Amount is invalid'
        ]
      end
    end
  end

  describe '#update_transfer' do
    let(:subject) { 'Hello World' }

    context 'when the api accepts the transfer' do
      before do
        stub_update_request(
          endpoint:        %r{/transfers/92bf870d-d914-4757-8691-7f8092a77e0e},
          request_headers: request_headers,
          response_body:   { id: '92bf870d-d914-4757-8691-7f8092a77e0e' }
        )
      end

      it 'returns the updated object' do
        transfer = client.update_transfer('92bf870d-d914-4757-8691-7f8092a77e0e', { subject: subject }, headers: request_headers)
        expect(transfer).to be_instance_of FidorApi::Model::Transfer::Generic
        expect(transfer.subject).to eq subject
      end
    end
  end

  describe '#confirm_transfer' do
    before do
      stub_update_request(
        endpoint:         %r{/transfers/92bf870d-d914-4757-8691-7f8092a77e0e/confirm},
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
      return_value = client.confirm_transfer('92bf870d-d914-4757-8691-7f8092a77e0e', headers: request_headers)
      expect(return_value.headers['Location']).to eq location
      expect(return_value.body['links']['redirect']).to eq redirect_link
    end
  end
end
