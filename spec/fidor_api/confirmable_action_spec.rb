require "spec_helper"

describe FidorApi::ConfirmableAction do

  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "e4e06da63df9449ddf4aa0cd4e07d079") }

  def expect_correct_action(action)
    expect(action).to be_instance_of FidorApi::ConfirmableAction
    expect(action.id).to              eq "8437c0c7-f704-4fc8-8ee0-3c18aedc8484"
    expect(action.steps_left).to      eq %w(otp)
    expect(action.steps_completed).to eq []
  end

  describe ".find" do
    it "returns one confirmable_action record" do
      VCR.use_cassette("confirmable_action/find", record: :once) do
        confirmable_action = client.confirmable_action "8437c0c7-f704-4fc8-8ee0-3c18aedc8484"
        expect_correct_action(confirmable_action)
      end
    end
  end

  describe ".refresh" do
    it "refreshes a confirmable action" do
      VCR.use_cassette("confirmable_action/refresh", record: :once) do
        expect {
          client.refresh_confirmable_action "1f4bd7eb-0e21-44bb-8a55-6a0385861ee3"
        }.to_not raise_error
      end
    end
  end

end
