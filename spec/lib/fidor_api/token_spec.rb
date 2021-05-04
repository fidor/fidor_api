require 'spec_helper'

module FidorApi
  RSpec.describe Token do
    let(:instance) { described_class.new(attributes) }

    let(:attributes) do
      {
        access_token:  'access-token',
        expires_in:    900,
        token_type:    'Bearer',
        refresh_token: 'refresh-token'
      }
    end

    describe '#to_h' do
      it 'returns all attributes in one hash' do
        expect(instance.to_h).to eq attributes
      end

      context 'when the token contains extra attributes' do
        let(:attributes_with_extra) do
          {
            access_token:    'access-token',
            expires_in:      900,
            token_type:      'Bearer',
            refresh_token:   'refresh-token',
            extra_attribute: 'value'
          }
        end

        let(:instance) { described_class.new(attributes_with_extra) }

        it 'returns all attributes in one hash and ignores the extra undefined ones' do
          expect(instance.to_h).to eq attributes
        end
      end
    end
  end
end
