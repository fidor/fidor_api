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

  describe "#to_hash" do
    let(:token) do
      FidorApi::Token.new(
        access_token:  "access-token",
        expires_in:    3600,
        token_type:    "bearer",
        refresh_token: "refresh-token",
        state:         "1234",
      )
    end

    it "returns a selected subset of attributes" do
      expect(token.to_hash).to eq(
        access_token:  token.access_token,
        expires_at:    token.expires_at,
        refresh_token: token.refresh_token,
        state:         token.state,
        token_type:    token.token_type
      )
    end
  end

end
