require 'spec_helper'

RSpec.describe 'DSL - Core Data' do
  let(:client)        { setup_client }
  let(:client_id)     { 'client-id' }
  let(:client_secret) { 'client-secret' }

  describe '#user' do
    before do
      stub_fetch_request(endpoint: %r{/users/current}, response_body: { id: 42 })
    end

    it 'returns the current user object' do
      user = client.user
      expect(user).to be_instance_of FidorApi::Model::User
      expect(user.id).to eq 42
    end
  end

  describe '#customers' do
    before do
      stub_fetch_request(endpoint: %r{/customers}, response_body: [{ id: 42 }])
    end

    it 'returns an array of customer objects' do
      customers = client.customers
      expect(customers).to be_instance_of FidorApi::Collection

      customer = customers.first
      expect(customer).to be_instance_of FidorApi::Model::Customer
      expect(customer.id).to eq 42
    end
  end

  describe '#accounts' do
    before do
      stub_fetch_request(endpoint: %r{/accounts}, response_body: [{ id: 42 }])
    end

    it 'returns an array of account objects' do
      accounts = client.accounts
      expect(accounts).to be_instance_of FidorApi::Collection

      account = accounts.first
      expect(account).to be_instance_of FidorApi::Model::Account
      expect(account.id).to eq 42
    end
  end
end
