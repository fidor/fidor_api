require 'spec_helper'

module FidorApi
  module Model
    module Transfer
      RSpec.describe Generic do
        describe 'dynamic attributes based on routing_type' do
          let(:transfer)     { described_class.new }
          let(:routing_type) { 'FOS_P2P_EMAIL' }
          let(:email)        { 'some.one@example.com' }

          it 'does not accept unknown routing_types' do
            expect { transfer.routing_type = 'INVALID' }.to raise_error Errors::NotSupported
          end

          it 'does not define the attributes before the routing_type is set' do
            expect { transfer.email = email }.to raise_error NoMethodError
          end

          it 'defines the attributes when routing_type is set' do
            transfer.routing_type = routing_type
            transfer.email = email
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
