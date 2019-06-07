require 'spec_helper'

module FidorApi
  module Model
    module Transfer
      RSpec.describe Generic do
        let(:transfer) { described_class.new }

        describe 'dynamic attributes based on routing_type' do
          let(:routing_type) { 'FOS_P2P_EMAIL' }
          let(:email)        { 'some.one@example.com' }

          it 'does not accept unknown routing_types' do
            expect { transfer.routing_type = 'INVALID' }.to raise_error Errors::NotSupported
          end

          it 'does not define the attributes before the routing_type is set' do
            expect { transfer.email = email }.to raise_error NoMethodError
          end

          it 'persists the routing_type and attributes in the beneficiary field' do
            transfer.routing_type = routing_type
            transfer.email = email
            expect(transfer.beneficiary).to eq(
              'routing_info' => { 'email' => email },
              'routing_type' => routing_type
            )
          end

          it 'also does the parsing when setting the beneficiary hash' do
            transfer.beneficiary = {
              'routing_type' => routing_type,
              'routing_info' => { 'email' => email }
            }
            expect(transfer.routing_type).to eq routing_type
            expect(transfer.email).to eq email
          end
        end

        describe 'virtual attributes for contact and bank details' do
          it 'sets the attributes in the beneficiary hash' do
            transfer.bank_name           = 'Any Bank'
            transfer.bank_address_line_1 = 'Any Address 1'
            transfer.bank_address_line_2 = 'Any Address 2'
            transfer.bank_city           = 'Any City'
            transfer.bank_country        = 'Any Country'

            transfer.contact_name           = 'Some One'
            transfer.contact_address_line_1 = 'Some Address 1'
            transfer.contact_address_line_2 = 'Some Address 2'
            transfer.contact_city           = 'Some City'
            transfer.contact_country        = 'Some Country'

            expect(transfer.beneficiary).to eq(
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
            transfer.beneficiary = {
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

            expect(transfer.bank_name).to           eq 'Any Bank'
            expect(transfer.bank_address_line_1).to eq 'Any Address 1'
            expect(transfer.bank_address_line_2).to eq 'Any Address 2'
            expect(transfer.bank_city).to           eq 'Any City'
            expect(transfer.bank_country).to        eq 'Any Country'

            expect(transfer.contact_name).to           eq 'Some One'
            expect(transfer.contact_address_line_1).to eq 'Some Address 1'
            expect(transfer.contact_address_line_2).to eq 'Some Address 2'
            expect(transfer.contact_city).to           eq 'Some City'
            expect(transfer.contact_country).to        eq 'Some Country'
          end
        end

        describe '#parse_errors' do
          let(:transfer) { described_class.new }

          let(:errors) do
            {
              'code'   => 422,
              'errors' => [
                { 'field' => 'amount', 'key' => 'invalid' },
                { 'field' => 'beneficiary.routing_info.email', 'key' => 'invalid' }
              ]
            }
          end

          it 'removes the prefix from error messages' do
            transfer.parse_errors(errors)
            expect(transfer.errors.full_messages).to eq [
              'Amount is invalid',
              'Email is invalid'
            ]
          end
        end
      end
    end
  end
end
