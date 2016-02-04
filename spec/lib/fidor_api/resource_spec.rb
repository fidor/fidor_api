require "spec_helper"

describe FidorApi::Resource do

  let(:access_token) { FidorApi::Token.new(access_token: token) }

  describe ".request" do
    context "with a invalid access_token" do
      let(:token) { "invalid" }

      it "raises FidorApi::UnauthorizedTokenError" do
        VCR.use_cassette("resource/invalid_token", record: :once) do
          expect {
            FidorApi::Resource.request(:get, access_token, "/users/current")
          }.to raise_error FidorApi::UnauthorizedTokenError
        end
      end
    end

    context "on any other error" do
      let(:token) { "f859032a6ca0a4abb2be0583b8347937" }

      it "raises FidorApi::ClientError" do
        VCR.use_cassette("resource/other_error", record: :once) do
          expect {
            FidorApi::Resource.request(:get, access_token, "/users/current")
          }.to raise_error FidorApi::ClientError
        end
      end
    end
  end

  class FidorApi::Dummy < FidorApi::Resource
    extend ModelAttribute

    attribute :id, :integer
  end

  describe ".model_name" do
    it "returns a ActiveModel::Name instance which does not include the FidorApi namespace" do
      resource = FidorApi::Dummy.new
      expect(resource.model_name.to_s).to eq "Dummy"
    end
  end

  describe "#persisted?" do
    subject { FidorApi::Dummy.new(id: id).persisted? }

    context "when the id attribute is set" do
      let(:id) { 42 }
      it { is_expected.to be true }
    end

    context "when the id attribute is no set" do
      let(:id) { nil }
      it { is_expected.to be false }
    end
  end

end
