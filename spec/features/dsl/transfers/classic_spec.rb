require 'spec_helper'

RSpec.describe 'DSL - Transfers - Classic' do
  let(:client)        { setup_client }
  let(:client_id)     { 'client-id' }
  let(:client_secret) { 'client-secret' }

  describe '#internal_transfers' do
    before do
      stub_fetch_request(endpoint: %r{/internal_transfers}, response_body: [{ id: 42 }, { id: 43 }])
    end

    it 'returns an array of internal-transfer objects' do
      transfers = client.internal_transfers
      expect(transfers).to be_instance_of FidorApi::Collection

      transfer = transfers.first
      expect(transfer).to be_instance_of FidorApi::Model::Transfer::Classic::Internal
      expect(transfer.id).to eq 42
    end
  end

  describe '#internal_transfer' do
    before do
      stub_fetch_request(endpoint: %r{/internal_transfers/42}, response_body: { id: 42 })
    end

    it 'returns an array of internal-transfer objects' do
      transfer = client.internal_transfer 42
      expect(transfer).to be_instance_of FidorApi::Model::Transfer::Classic::Internal
      expect(transfer.id).to eq 42
    end
  end

  describe '#new_internal_transfer' do
    let(:subject) { 'Hello World' }

    it 'returns a new instance of the internal-transfer model' do
      transfer = client.new_internal_transfer(subject: subject)
      expect(transfer).to be_instance_of FidorApi::Model::Transfer::Classic::Internal
      expect(transfer.subject).to eq subject
    end
  end

  describe '#create_internal_transfer' do
    let(:subject) { 'Hello World' }

    context 'when the api accepts the transfer' do
      before do
        stub_create_request(endpoint: %r{/internal_transfers}, response_body: { id: 42 })
      end

      it 'assigns the id attribute' do
        transfer = client.create_internal_transfer(subject: subject)
        expect(transfer).to be_instance_of FidorApi::Model::Transfer::Classic::Internal
        expect(transfer.id).to eq 42
      end
    end

    context 'when the api rejects the transfer' do
      before do
        stub_create_request(endpoint: %r{/internal_transfers}, response_body: errors, status: 422)
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
        transfer = client.create_internal_transfer(subject: subject)
        expect(transfer).to be_instance_of FidorApi::Model::Transfer::Classic::Internal
        expect(transfer.errors.full_messages).to eq [
          'Something went wrong',
          'Amount is invalid'
        ]
      end
    end
  end

  describe '#sepa_transfers' do
    before do
      stub_fetch_request(endpoint: %r{/sepa_credit_transfers}, response_body: [{ id: 42 }, { id: 43 }])
    end

    it 'returns an array of sepa-transfer objects' do
      transfers = client.sepa_transfers
      expect(transfers).to be_instance_of FidorApi::Collection

      transfer = transfers.first
      expect(transfer).to be_instance_of FidorApi::Model::Transfer::Classic::SEPA
      expect(transfer.id).to eq 42
    end
  end

  describe '#sepa_transfer' do
    before do
      stub_fetch_request(endpoint: %r{/sepa_credit_transfers/42}, response_body: { id: 42 })
    end

    it 'returns an array of sepa-transfer objects' do
      transfer = client.sepa_transfer 42
      expect(transfer).to be_instance_of FidorApi::Model::Transfer::Classic::SEPA
      expect(transfer.id).to eq 42
    end
  end

  describe '#new_sepa_transfer' do
    let(:subject) { 'Hello World' }

    it 'returns a new instance of the sepa-transfer model' do
      transfer = client.new_sepa_transfer(subject: subject)
      expect(transfer).to be_instance_of FidorApi::Model::Transfer::Classic::SEPA
      expect(transfer.subject).to eq subject
    end
  end

  describe '#create_sepa_transfer' do
    let(:subject) { 'Hello World' }

    context 'when the api accepts the transfer' do
      before do
        stub_create_request(endpoint: %r{/sepa_credit_transfers}, response_body: { id: 42 })
      end

      it 'assigns the id attribute' do
        transfer = client.create_sepa_transfer(subject: subject)
        expect(transfer).to be_instance_of FidorApi::Model::Transfer::Classic::SEPA
        expect(transfer.id).to eq 42
      end
    end

    context 'when the api rejects the transfer' do
      before do
        stub_create_request(endpoint: %r{/sepa_credit_transfers}, response_body: errors, status: 422)
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
        transfer = client.create_sepa_transfer(subject: subject)
        expect(transfer).to be_instance_of FidorApi::Model::Transfer::Classic::SEPA
        expect(transfer.errors.full_messages).to eq [
          'Something went wrong',
          'Amount is invalid'
        ]
      end
    end
  end
end
