require 'spec_helper'

RSpec.describe 'DSL - Accounts' do
  let(:client)        { setup_client }
  let(:client_id)     { 'client-id' }
  let(:client_secret) { 'client-secret' }

  describe '#account_transactions' do
    before do
      stub_fetch_request(endpoint: %r{/accounts/123456/transactions}, response_body: [{ id: 42 }, { id: 43 }])
    end

    it 'returns a collection of transactions' do
      transactions = client.account_transactions('123456')
      expect(transactions).to be_instance_of FidorApi::Collection

      transaction = transactions.first
      expect(transaction).to be_instance_of FidorApi::Model::Transaction
      expect(transaction.id).to eq 42
    end
  end

  describe '#account_transaction' do
    before do
      stub_fetch_request(endpoint: %r{/accounts/123/transactions/456}, response_body: { id: 42 })
    end

    it 'returns single transaction' do
      transaction = client.account_transaction('123', '456')
      expect(transaction).to be_instance_of FidorApi::Model::Transaction
      expect(transaction.id).to eq 42
    end
  end
end
