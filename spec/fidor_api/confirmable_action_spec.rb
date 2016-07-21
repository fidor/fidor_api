require "spec_helper"

describe FidorApi::ConfirmableAction do

  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "0816d2665999fbd76a69c6f0050a49fA") }

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

end

