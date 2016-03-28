require "spec_helper"

describe FidorApi::Message do

  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "635490b2e0946ea636b92ae839681380") }

  def expect_correct_message(message)
    expect(message).to be_instance_of FidorApi::Message
    expect(message.id).to         eq 42
    expect(message.subject).to    eq "Hello World"
    expect(message.type).to       eq "advantage_offer"
    expect(message.opened_at).to  eq DateTime.new(2016, 3, 18, 13, 24, 43)
    expect(message.created_at).to eq DateTime.new(2016, 3, 18, 12, 47, 19)
    expect(message.updated_at).to eq DateTime.new(2016, 3, 18, 13, 24, 43)
    expect(message.category).to   eq "Angebote"
  end

  describe ".all" do
    it "returns all message records" do
      VCR.use_cassette("message/all", record: :once) do
        messages = client.messages
        expect(messages).to be_instance_of FidorApi::Collection
        expect_correct_message(messages.first)
      end
    end
  end

  describe ".find" do
    it "returns one message record" do
      VCR.use_cassette("message/find", record: :once) do
        message = client.message 42
        expect_correct_message(message)
      end
    end
  end

end
