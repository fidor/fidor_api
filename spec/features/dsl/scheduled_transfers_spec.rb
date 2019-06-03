require 'spec_helper'

RSpec.describe 'DSL - Scheduled Transfer' do
  let(:client)                { setup_client }
  let(:client_id)             { 'client-id' }
  let(:client_secret)         { 'client-secret' }

  before do
    client.config.environment = FidorApi::Environment::Future.new
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
end
