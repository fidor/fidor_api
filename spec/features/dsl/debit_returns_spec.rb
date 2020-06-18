require 'spec_helper'

RSpec.describe 'DSL - Debit Returns' do
  let(:client)                { setup_client }
  let(:client_id)             { 'client-id' }
  let(:client_secret)         { 'client-secret' }
  let(:confirmable_action_id) { '15fcc0cb-b741-4e96-b4bf-bb5b2ce79609' }

  let(:transaction_id) { '12345' }

  describe '#debit_return' do
    before do
      stub_fetch_request(
        endpoint:      %r{/transactions/#{transaction_id}/debit_return},
        response_body: { state: 'created' }
      )
    end

    it 'returns a debit return object' do
      debit_return = client.debit_return transaction_id
      expect(debit_return).to be_instance_of FidorApi::Model::DebitReturn
      expect(debit_return.state).to eq 'created'
    end
  end

  describe '#create_debit_return' do
    let(:confirmable_url) { "https://api.example.com/confirmable/actions/#{confirmable_action_id}" }

    context 'when the api accepts the debit return' do
      before do
        stub_create_request(
          endpoint:      %r{/transactions/#{transaction_id}/debit_return},
          response_body: { state: 'created' }
        )
      end

      it 'assigns the attributes' do
        debit_return = client.create_debit_return(transaction_id)
        expect(debit_return).to be_instance_of FidorApi::Model::DebitReturn
        expect(debit_return.state).to eq 'created'
      end
    end

    context 'when the api rejects the transfer' do
      before do
        stub_create_request(endpoint: %r{/transactions/#{transaction_id}/debit_return}, response_body: errors, status: 422)
      end

      let(:errors) do
        {
          'status' => '422',
          'errors' => [
            { 'field' => 'base', 'message' => 'Something went wrong' }
          ]
        }
      end

      it 'assigns the errors' do
        debit_return = client.create_debit_return(transaction_id)
        expect(debit_return).to be_instance_of FidorApi::Model::DebitReturn
        expect(debit_return.errors.full_messages).to eq [
          'Something went wrong'
        ]
      end
    end
  end

  describe '#confirm_debit_return' do
    before do
      stub_update_request(
        endpoint:         %r{/transactions/#{transaction_id}/debit_return/confirm},
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
      return_value = client.confirm_debit_return(transaction_id)
      expect(return_value.headers['Location']).to eq location
      expect(return_value.body['links']['redirect']).to eq redirect_link
    end
  end
end
