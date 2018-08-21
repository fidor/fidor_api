require 'spec_helper'

RSpec.describe 'DSL - Confirmable Actions' do
  let(:client)        { setup_client }
  let(:client_id)     { 'client-id' }
  let(:client_secret) { 'client-secret' }

  describe '#confirmable_action' do
    before do
      stub_fetch_request(
        endpoint:      %r{/confirmable/actions/1e1f2345-863e-486e-a2f3-377a8a12a79d},
        response_body: { id: '1e1f2345-863e-486e-a2f3-377a8a12a79d' }
      )
    end

    it 'returns the current user object' do
      confirmable_action = client.confirmable_action '1e1f2345-863e-486e-a2f3-377a8a12a79d'
      expect(confirmable_action).to be_instance_of FidorApi::Model::ConfirmableAction
      expect(confirmable_action.id).to eq '1e1f2345-863e-486e-a2f3-377a8a12a79d'
    end
  end

  describe '#refresh_confirmable_action' do
    before do
      stub_update_request(
        endpoint:      %r{/confirmable/actions/1e1f2345-863e-486e-a2f3-377a8a12a79d/refresh},
        response_body: { id: '1e1f2345-863e-486e-a2f3-377a8a12a79d' }
      )
    end

    it 'returns the current user object' do
      confirmable_action = client.refresh_confirmable_action '1e1f2345-863e-486e-a2f3-377a8a12a79d'
      expect(confirmable_action).to be_instance_of FidorApi::Model::ConfirmableAction
      expect(confirmable_action.id).to eq '1e1f2345-863e-486e-a2f3-377a8a12a79d'
    end
  end

  describe '#update_confirmable_action' do
    before do
      stub_update_request(
        endpoint:      %r{/confirmable/actions/1e1f2345-863e-486e-a2f3-377a8a12a79d},
        response_body: { id: '1e1f2345-863e-486e-a2f3-377a8a12a79d' }
      )
    end

    it 'returns the current user object' do
      confirmable_action = client.update_confirmable_action '1e1f2345-863e-486e-a2f3-377a8a12a79d', otp: '123456'
      expect(confirmable_action).to be_instance_of FidorApi::Model::ConfirmableAction
      expect(confirmable_action.id).to eq '1e1f2345-863e-486e-a2f3-377a8a12a79d'
    end
  end
end
