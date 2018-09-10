require 'spec_helper'

RSpec.describe 'DSL - Preauths' do
  let(:client)        { setup_client }
  let(:client_id)     { 'client-id' }
  let(:client_secret) { 'client-secret' }

  describe '#preauths' do
    before do
      stub_fetch_request(endpoint: %r{/preauths}, response_body: [{ id: 42 }, { id: 43 }])
    end

    it 'returns the current user object' do
      preauths = client.preauths
      expect(preauths).to be_instance_of FidorApi::Collection

      preauth = preauths.first
      expect(preauth).to be_instance_of FidorApi::Model::Preauth
      expect(preauth.id).to eq 42
    end
  end

  describe '#preauth' do
    before do
      stub_fetch_request(endpoint: %r{/preauths/42}, response_body: { id: 42 })
    end

    it 'returns the current user object' do
      preauth = client.preauth 42
      expect(preauth).to be_instance_of FidorApi::Model::Preauth
      expect(preauth.id).to eq 42
    end
  end
end
