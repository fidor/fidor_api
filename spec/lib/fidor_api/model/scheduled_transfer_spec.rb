require 'spec_helper'

module FidorApi
  module Model
    RSpec.describe ScheduledTransfer do
      describe 'attributes' do
        subject { described_class.new(amount: '100') }
        it do
          expect(subject.amount.class).to eql(BigDecimal)
          expect(subject.amount.to_digits).to eql('100.0')
        end
      end
    end
  end
end
