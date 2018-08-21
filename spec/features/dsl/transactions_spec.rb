require 'spec_helper'

RSpec.describe 'DSL - Transactions' do
  let(:client)        { setup_client }
  let(:client_id)     { 'client-id' }
  let(:client_secret) { 'client-secret' }

  describe '#transactions' do
    before do
      stub_fetch_request(endpoint: %r{/transactions}, response_body: [{ id: 42 }, { id: 43 }])
    end

    it 'returns the current user object' do
      transactions = client.transactions
      expect(transactions).to be_instance_of FidorApi::Collection

      transaction = transactions.first
      expect(transaction).to be_instance_of FidorApi::Model::Transaction
      expect(transaction.id).to eq 42
    end
  end

  describe '#transaction' do
    before do
      stub_fetch_request(endpoint: %r{/transactions/42}, response_body: { id: 42 })
    end

    it 'returns the current user object' do
      transaction = client.transaction 42
      expect(transaction).to be_instance_of FidorApi::Model::Transaction
      expect(transaction.id).to eq 42
    end
  end
end
