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

  it 'supports query params' do
    stub_fetch_request(endpoint: %r{/users/current},
      request_params: {query: {fields: 'id,email'}},
      response_body: {id: 42, email: 'example@email.org'})

    user = client.user fields: 'id,email'

    expect(user.id).to eq 42
    expect(user.email).to eq 'example@email.org'
  end

  it 'supports per-instance headers' do
    stub_fetch_request(endpoint: %r{/accounts},
      request_params: {headers: {'Any-Header' => 'Basic stuff'}}, response_body: [id: 42])

    account = client.accounts(headers: {'Any-Header' => 'Basic stuff'}).first

    expect(account.id).to eq 42
  end
end
