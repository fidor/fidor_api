require "spec_helper"

describe FidorApi::Transfer do

  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "f859032a6ca0a4abb2be0583b8347937") }

  describe FidorApi::Transfer::FPS do

    subject do
      client.build_fps_transfer(
        account_id:       1,
        external_uid:     "4279762F8",
        remote_account:   "87654321",
        remote_sort_code: "654321",
        remote_name:      "John Doe",
        amount:           BigDecimal.new("10.00"),
        subject:          "Money for you"
      )
    end

    describe "validations" do
      it { is_expected.to validate_presence_of :account_id       }
      it { is_expected.to validate_presence_of :external_uid     }
      it { is_expected.to validate_presence_of :remote_account   }
      it { is_expected.to validate_presence_of :remote_sort_code }
      it { is_expected.to validate_presence_of :remote_name      }
      it { is_expected.to validate_presence_of :amount           }
      it { is_expected.to validate_presence_of :subject          }
    end

    describe "#save" do
      context "on success" do
        it "returns true and updates the attributes with received data" do
          VCR.use_cassette("transfer/fps/save_success", record: :once) do
            expect(subject.save).to be true

            expect(subject.id).to    eq 5
            expect(subject.state).to eq "received"
          end
        end
      end

      context "on invalid object" do
        it "raises an error" do
          subject.account_id = nil

          expect { subject.save }.to raise_error FidorApi::InvalidRecordError
        end
      end

      context "on failure response" do
        it "returns false and provides errors" do
          subject.account_id = 999

          VCR.use_cassette("transfer/fps/save_failure", record: :once) do
            expect(subject.save).to be false
            expect(subject.errors[:account_id]).to eq ["anything"]
          end
        end
      end
    end

    describe "#as_json" do
      it "returns all writeable fields" do
        expect(subject.as_json).to eq(
          account_id:       "1",
          amount:           1000,
          external_uid:     "4279762F8",
          remote_account:   "87654321",
          remote_sort_code: "654321",
          remote_name:      "John Doe",
          subject:          "Money for you"
        )
      end
    end

    def expect_correct_transfer(transfer)
      expect(transfer).to be_instance_of FidorApi::Transfer::FPS
      expect(transfer.id).to               eq 5
      expect(transfer.account_id).to       eq "1"
      expect(transfer.user_id).to          eq "1"
      expect(transfer.transaction_id).to   be_nil
      expect(transfer.remote_account).to   eq "87654321"
      expect(transfer.remote_sort_code).to eq "654321"
      expect(transfer.remote_name).to      eq "John Doe"
      expect(transfer.external_uid).to     eq "4279762F8"
      expect(transfer.amount).to           eq BigDecimal.new("10.00")
      expect(transfer.currency).to         be_nil
      expect(transfer.subject).to          eq "Money for you"
      expect(transfer.state).to            eq "received"
      expect(transfer.created_at).to       eq Time.new(2016, 4, 13, 20, 2, 34, "+00:00")
      expect(transfer.updated_at).to       eq Time.new(2016, 4, 13, 20, 2, 34, "+00:00")
    end

    describe ".all" do
      it "returns all transfer records" do
        VCR.use_cassette("transfer/fps/all", record: :once) do
          transfers = client.fps_transfers
          expect(transfers).to be_instance_of FidorApi::Collection
          expect_correct_transfer transfers.first
        end
      end
    end

    describe ".find" do
      it "returns one record" do
        VCR.use_cassette("transfer/fps/find", record: :once) do
          transfer = client.fps_transfer 5
          expect(transfer).to be_instance_of FidorApi::Transfer::FPS
          expect_correct_transfer transfer
        end
      end
    end

  end

end

