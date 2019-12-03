require 'spec_helper'

module FidorApi
  module Model
    class Anything < Base
      attribute :id,     :integer
      attribute :amount, :integer

      attribute_decimal_methods :amount
    end

    RSpec.describe Base do
      describe '.attribute_decimal_methods' do
        let(:instance) { Anything.new }

        it 'allows to set integer attributes with decimal values' do
          instance.amount = 42
          expect(instance.attributes[:amount]).to eq 42

          instance.amount = '42.23'
          expect(instance.attributes[:amount]).to eq 4223

          instance.amount = BigDecimal('42.23')
          expect(instance.attributes[:amount]).to eq 4223
        end

        it 'allows to read integer attributes as decimal' do
          instance.amount = 1337
          expect(instance.amount).to eq BigDecimal('13.37')
        end
      end

      describe '.model_name' do
        it "returns the model's name without namespaces" do
          expect(Anything.model_name.to_s).to eq 'Anything'
        end
      end

      describe '#initialize' do
        it 'converts data types' do
          model = Anything.new(id: '42')
          expect(model.id).to eq 42
        end

        it 'ignores unknown keys' do
          model = Anything.new(id: 42, unknown: 'x')
          expect(model.id).to eq 42
        end
      end

      describe '#model_name' do
        it "returns the model's name without namespaces" do
          model = Anything.new
          expect(model.model_name.to_s).to eq 'Anything'
        end
      end

      describe '#parse_errors' do
        let(:instance) { Anything.new }

        let(:errors) do
          {
            'code'   => 422,
            'errors' => [
              { 'field' => 'base', 'message' => 'Something is wrong in general' },
              { 'field' => 'amount', 'key' => 'greater_than', 'count' => 0 },
              { 'field' => 'amount', 'key' => 'invalid', 'message' => 'is not valid' }
            ]
          }
        end

        it 'assigns the errors and supports i18n keys' do
          instance.parse_errors(errors)
          expect(instance.errors[:base]).to eq ['Something is wrong in general']
          expect(instance.errors[:amount]).to eq ['must be greater than 0', 'is invalid']
        end
      end

      describe '#persisted?' do
        subject { Anything.new(id: id).persisted? }

        context 'for objects with an id set' do
          let(:id) { 42 }

          it { is_expected.to be true }
        end
      end
    end
  end
end
