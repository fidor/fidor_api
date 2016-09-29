require "spec_helper"

describe FidorApi::CardLimits do
  subject { described_class.new }

  before do
    FidorApi::Connectivity.access_token = '157a51be230c2d7f186d7bb249d41d75'
  end

  describe 'validations' do
    it 'validates limits' do
      subject.atm_limit = 1345.05
      expect(subject).to_not be_valid
      subject.atm_limit = '1345a'
      expect(subject).to_not be_valid
      subject.atm_limit = 1234
      expect(subject).to be_valid
    end
  end

  describe ".find" do
    it "returns one card_limits record" do
      VCR.use_cassette("card_limits/find", record: :once) do
        limits = FidorApi::CardLimits.find 7
        expect(limits.id).to           eq 7
        expect(limits.atm_limit).to    eq 250_00
        expect(limits.single_limit).to eq 100_000
        expect(limits.volume_limit).to eq 100_000
      end
    end
  end

  describe '#update' do
    it "changes the card_limits record" do
      VCR.use_cassette("card_limits/change", record: :once) do
        expect {
          FidorApi::CardLimits.new(
            id: 7,
            single_limit: BigDecimal.new("2000.0"),
            volume_limit: BigDecimal.new("2000.0")
          ).save
        }.to raise_error(FidorApi::ApprovalRequired)
      end
    end
  end
end
