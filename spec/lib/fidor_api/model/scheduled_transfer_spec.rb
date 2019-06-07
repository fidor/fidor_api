require 'spec_helper'

module FidorApi
  module Model
    RSpec.describe ScheduledTransfer do
      let(:scheduled_transfer) { described_class.new }

      describe 'dynamic attributes based on routing_type' do
        let(:routing_type)   { 'FOS_P2P_ACCOUNT_NUMBER' }
        let(:account_number) { '12345678' }

        it 'does not accept unknown routing_types' do
          expect { scheduled_transfer.routing_type = 'INVALID' }.to raise_error Errors::NotSupported
        end

        it 'does not define the attributes before the routing_type is set' do
          expect { scheduled_transfer.account_number = account_number }.to raise_error NoMethodError
        end

        it 'defines the attributes when routing_type is set' do
          scheduled_transfer.routing_type = routing_type
          scheduled_transfer.account_number = account_number
        end

        it 'persists the routing_type and attributes in the beneficiary field' do
          scheduled_transfer.routing_type = routing_type
          scheduled_transfer.account_number = account_number
          expect(scheduled_transfer.beneficiary).to eq(
            'routing_info' => { 'account_number' => account_number },
            'routing_type' => routing_type
          )
        end

        it 'also does the parsing when setting the beneficiary hash' do
          scheduled_transfer.beneficiary = {
            'routing_type' => routing_type,
            'routing_info' => { 'account_number' => account_number }
          }
          expect(scheduled_transfer.routing_type).to eq routing_type
          expect(scheduled_transfer.account_number).to eq account_number
        end
      end

      describe 'virtual attributes for contact and bank details' do
        it 'sets the attributes in the beneficiary hash' do
          scheduled_transfer.bank_name           = 'Any Bank'
          scheduled_transfer.bank_address_line_1 = 'Any Address 1'
          scheduled_transfer.bank_address_line_2 = 'Any Address 2'
          scheduled_transfer.bank_city           = 'Any City'
          scheduled_transfer.bank_country        = 'Any Country'

          scheduled_transfer.contact_name           = 'Some One'
          scheduled_transfer.contact_address_line_1 = 'Some Address 1'
          scheduled_transfer.contact_address_line_2 = 'Some Address 2'
          scheduled_transfer.contact_city           = 'Some City'
          scheduled_transfer.contact_country        = 'Some Country'

          expect(scheduled_transfer.beneficiary).to eq(
            'bank'    => {
              'name'           => 'Any Bank',
              'address_line_1' => 'Any Address 1',
              'address_line_2' => 'Any Address 2',
              'city'           => 'Any City',
              'country'        => 'Any Country'
            },
            'contact' => {
              'name'           => 'Some One',
              'address_line_1' => 'Some Address 1',
              'address_line_2' => 'Some Address 2',
              'city'           => 'Some City',
              'country'        => 'Some Country'
            }
          )
        end

        it 'reads the attributes from the beneficiary hash' do
          scheduled_transfer.beneficiary = {
            'bank'         => {
              'name'           => 'Any Bank',
              'address_line_1' => 'Any Address 1',
              'address_line_2' => 'Any Address 2',
              'city'           => 'Any City',
              'country'        => 'Any Country'
            },
            'contact'      => {
              'name'           => 'Some One',
              'address_line_1' => 'Some Address 1',
              'address_line_2' => 'Some Address 2',
              'city'           => 'Some City',
              'country'        => 'Some Country'
            },
            'routing_type' => 'SEPA'
          }

          expect(scheduled_transfer.bank_name).to           eq 'Any Bank'
          expect(scheduled_transfer.bank_address_line_1).to eq 'Any Address 1'
          expect(scheduled_transfer.bank_address_line_2).to eq 'Any Address 2'
          expect(scheduled_transfer.bank_city).to           eq 'Any City'
          expect(scheduled_transfer.bank_country).to        eq 'Any Country'

          expect(scheduled_transfer.contact_name).to           eq 'Some One'
          expect(scheduled_transfer.contact_address_line_1).to eq 'Some Address 1'
          expect(scheduled_transfer.contact_address_line_2).to eq 'Some Address 2'
          expect(scheduled_transfer.contact_city).to           eq 'Some City'
          expect(scheduled_transfer.contact_country).to        eq 'Some Country'
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
