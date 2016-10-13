require "spec_helper"

describe FidorApi::Password do
  describe ".request_new" do
    it "does an api call and returns the confirmed attribute of the result" do
      VCR.use_cassette("password/request_new") do
        result = described_class.request_new("foo@example.com")
        expect(result).to be true
      end
    end
  end

  describe ".update" do
    it "does an api call and returns the confirmed attribute of the result" do
      VCR.use_cassette("password/update") do
        result = described_class.update(
          type:             "reset_token",
          token:            "AsCsZn73D2ktsFxtJZLr",
          password:         "12345678",
          confirm_password: "12345678"
        )
        expect(result).to be true
      end
    end
  end
end
