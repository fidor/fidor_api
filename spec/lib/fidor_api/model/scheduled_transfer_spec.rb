require 'spec_helper'

module FidorApi
  module Model
    RSpec.describe ScheduledTransfer do
      describe 'attributes' do
        subject { described_class.new(amount: "100") }
        it { is_expected.to respond_to(:id) }
        it { is_expected.to respond_to(:account_id) }
        it { is_expected.to respond_to(:external_uid) }
        it { is_expected.to respond_to(:amount) }
        it { is_expected.to respond_to(:currency) }
        it { is_expected.to respond_to(:subject) }
        it { is_expected.to respond_to(:status) }
        it { is_expected.to respond_to(:scheduled_date) }
        it do
          expect(subject.amount.class).to eql(BigDecimal)
          expect(subject.amount.to_digits).to eql("100.0")
        end
      end
    end
  end
end
