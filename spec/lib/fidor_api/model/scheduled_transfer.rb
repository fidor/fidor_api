require 'spec_helper'

module FidorApi
  module Model
    RSpec.describe ScheduledTransfer do
      describe 'attributes' do
        subject { described_class.new }
        it { is_expected.to respond_to(:id) }
        it { is_expected.to respond_to(:account_id) }
        it { is_expected.to respond_to(:external_uid) }
        it { is_expected.to respond_to(:amount) }
        it { is_expected.to respond_to(:currency) }
        it { is_expected.to respond_to(:subject) }
        it { is_expected.to respond_to(:status) }
      end
    end
  end
end
