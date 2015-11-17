require "spec_helper"

describe FidorApi::Token do

  describe "#valid?" do

    subject { FidorApi::Token.new(expires_at: expires_at).valid? }

    context "when the :expires_at value is in the future" do
      let(:expires_at) { Time.now + 1.hour }

      it { is_expected.to be true }
    end

    context "when the :expires_at value is in the past" do
      let(:expires_at) { Time.now - 1.hour }

      it { is_expected.to be false }
    end

  end

end
