require "spec_helper"

describe FidorApi::AmountAttributes do

  class DummyModel
    include ActiveModel::Model
    extend ModelAttribute
    extend FidorApi::AmountAttributes

    attribute :attr1, :integer
    attribute :attr2, :integer
    attribute :attr3, :integer

    amount_attribute :amount1
    amount_attribute :amount2
  end

  let(:resource) { DummyModel.new(attr1: 1, attr2: 2, attr3: 3) }

  describe "#amount" do
    it "returns the amount as big decimal" do
      resource.amount1 = 1234
      expect(resource.amount1).to eq BigDecimal.new("12.34")
    end
  end

  describe "#amount=" do
    it "allows to pass nil" do
      resource.amount2 = nil
      expect(resource.amount2).to be_nil
    end

    it "allows to pass integer" do
      resource.amount2 = 1234
      expect(resource.amount2).to eq BigDecimal.new("12.34")
    end

    it "allows to pass big decimal" do
      resource.amount2 = BigDecimal.new("12.34")
      expect(resource.amount2).to eq BigDecimal.new("12.34")
    end

    it "does not allow to pass float" do
      expect {
        resource.amount2 = 12.34
      }.to raise_error(ArgumentError)
    end

    it "does not allow to pass string" do
      expect {
        resource.amount2 = "12.34"
      }.to raise_error(ArgumentError)
    end
  end

  describe "#attributes" do
    it "returns all regular attributes plus the amount one" do
      expect(resource.attributes.keys).to eq [:attr1, :attr2, :attr3, :amount1, :amount2]
    end
  end

end
