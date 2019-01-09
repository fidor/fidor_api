require 'spec_helper'

module FidorApi
  module Model
    RSpec.describe StandingOrder do
      let(:standing_order) { described_class.new }

      describe 'dynamic attributes based on routing_type' do
        let(:routing_type)   { 'FOS_P2P_ACCOUNT_NUMBER' }
        let(:account_number) { '12345678' }

        it 'does not accept unknown routing_types' do
          expect { standing_order.routing_type = 'INVALID' }.to raise_error Errors::NotSupported
        end

        it 'does not define the attributes before the routing_type is set' do
          expect { standing_order.account_number = account_number }.to raise_error NoMethodError
        end

        it 'defines the attributes when routing_type is set' do
          standing_order.routing_type = routing_type
          standing_order.account_number = account_number
        end

        it 'persists the routing_type and attributes in the beneficiary field' do
          standing_order.routing_type = routing_type
          standing_order.account_number = account_number
          expect(standing_order.beneficiary).to eq(
            'routing_info' => { 'account_number' => account_number },
            'routing_type' => routing_type
          )
        end

        it 'also does the parsing when setting the beneficiary hash' do
          standing_order.beneficiary = {
            'routing_type' => routing_type,
            'routing_info' => { 'account_number' => account_number }
          }
          expect(standing_order.routing_type).to eq routing_type
          expect(standing_order.account_number).to eq account_number
        end
      end

      describe 'virtual attributes for schedule' do
        let(:schedule_params) do
          {
            'rhythm'               => 'weekly',
            'runtime_day_of_month' => '1',
            'runtime_day_of_week'  => 'Mon',
            'start_date'           => '2019-06-24',
            'ultimate_run'         => '2019-07-24'
          }
        end

        it 'sets the attributes in the schedule hash' do
          standing_order.rhythm               = schedule_params['rhythm']
          standing_order.runtime_day_of_month = schedule_params['runtime_day_of_month']
          standing_order.runtime_day_of_week  = schedule_params['runtime_day_of_week']
          standing_order.start_date           = schedule_params['start_date']
          standing_order.ultimate_run         = schedule_params['ultimate_run']

          expect(standing_order.schedule).to eq schedule_params
        end

        it 'reads the attributes from the schedule hash' do
          standing_order.schedule = schedule_params

          expect(standing_order.rhythm).to eq schedule_params['rhythm']
          expect(standing_order.runtime_day_of_month).to eq schedule_params['runtime_day_of_month']
          expect(standing_order.runtime_day_of_week).to eq schedule_params['runtime_day_of_week']
          expect(standing_order.start_date).to eq schedule_params['start_date']
          expect(standing_order.ultimate_run).to eq schedule_params['ultimate_run']
        end
      end

      describe '#parse_errors' do
        let(:transfer) { described_class.new }

        let(:errors) do
          {
            'code'   => 422,
            'errors' => [
              { 'field' => 'amount', 'key' => 'invalid' },
              { 'field' => 'beneficiary.routing_info.account_number', 'key' => 'invalid' }
            ]
          }
        end

        it 'removes the prefix from error messages' do
          transfer.parse_errors(errors)
          expect(transfer.errors.full_messages).to eq [
            'Amount is invalid',
            'Account number is invalid'
          ]
        end
      end
    end
  end
end
