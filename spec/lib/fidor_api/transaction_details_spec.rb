require "spec_helper"

describe FidorApi::TransactionDetails do
  let(:default_remote) { "Fidor Bank" }

  describe FidorApi::TransactionDetails::Transfer do
    describe "#remote_display_name" do
      subject { described_class.new(attributes).remote_display_name }

      context "when remote_name is set" do
        let(:attributes) { { remote_name: "Remote Name", remote_nick: "Remote Nick" } }
        it { is_expected.to eq attributes[:remote_name] }
      end

      context "when remote_nick is set" do
        let(:attributes) { { remote_nick: "Remote Nick" } }
        it { is_expected.to eq attributes[:remote_nick] }
      end

      context "when both attributes are not set" do
        let(:attributes) { {} }
        it { is_expected.to eq default_remote }
      end
    end
  end

  describe FidorApi::TransactionDetails::CreditCard do
    describe "#remote_display_name" do
      subject { described_class.new(attributes).remote_display_name }

      context "when cc_merchant_name attributes is set" do
        let(:attributes) { { cc_merchant_name: "CC Merchant Name" } }
        it { is_expected.to eq attributes[:cc_merchant_name] }
      end

      context "when the attribute is not set" do
        let(:attributes) { {} }
        it { is_expected.to eq default_remote }
      end
    end
  end

  describe FidorApi::TransactionDetails::Unknown do
    subject { described_class.new.remote_display_name }

    describe "#remote_display_name" do
      it { is_expected.to eq default_remote }
    end
  end
end
