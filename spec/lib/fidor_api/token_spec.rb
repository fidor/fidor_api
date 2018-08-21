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
    end
  end
end
