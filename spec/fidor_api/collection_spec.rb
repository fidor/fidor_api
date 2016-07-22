require "spec_helper"

describe FidorApi::Collection do

  class Dummy
    include ActiveModel::Model
    attr_accessor :a, :b, :c

    def ==(other)
      other.a == a &&
      other.b == b &&
      other.c == c
    end
  end

  subject { FidorApi::Collection.build(Dummy, data) }

  describe "#initialize" do

    let(:data) do
      {
        "data" => [
          { "a" => 1, "b" => 2, "c" => 3 }
        ],
        "collection" => {
          "total_pages"   => 2,
          "current_page"  => 1,
          "per_page"      => 10,
          "total_entries" => 20
        }
      }
    end

    it "allows to access the passed data" do
      expect(subject.first).to be_instance_of Dummy
      expect(subject.first.a).to eq 1
    end

    it "it uses the passed collection information" do
      expect(subject.total_pages).to  eq 2
      expect(subject.current_page).to eq 1
      expect(subject.limit_value).to  eq 10
      expect(subject.total_entries).to  eq 20
    end
  end

  describe "kaminari interface" do

    let(:collection) { FidorApi::Collection.new(current_page: current_page, total_pages: total_pages) }

    describe "#last_page?" do
      subject { collection.last_page? }

      context "on the last page" do
        let(:current_page) { 10 }
        let(:total_pages)  { 10 }

        it { is_expected.to be true }
      end

      context "on any other page" do
        let(:current_page) { 1 }
        let(:total_pages)  { 5 }

        it { is_expected.to be false }
      end
    end

    describe "#next_page" do
      let(:current_page) { 1 }
      let(:total_pages)  { 2 }

      it "returns an increment of current_page" do
        expect(collection.next_page).to eq collection.current_page + 1
      end
    end

  end

  describe "implements the enumerable mixin" do
    subject { FidorApi::Collection.new }

    it { is_expected.to be_a Enumerable }
    it { is_expected.to respond_to :each }
  end

end
