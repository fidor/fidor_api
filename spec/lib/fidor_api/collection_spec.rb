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

    context "when the data passed is a hash" do
      let(:data) do
        {
          "data" => [
            { "a" => 1, "b" => 2, "c" => 3 }
          ],
          "collection" => {
            "total_pages"  => 2,
            "current_page" => 1,
            "per_page"     => 10
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
      end
    end

    context "when the data passed is a array" do
      let(:data) do
        [
          { "a" => 1, "b" => 2, "c" => 3 }
        ]
      end

      it "allows to access the passed data" do
        expect(subject.first).to be_instance_of Dummy
        expect(subject.first.a).to eq 1
      end

      it "it calculates the collection information" do
        expect(subject.total_pages).to  eq 1
        expect(subject.current_page).to eq 1
        expect(subject.limit_value).to  eq 1
      end
    end
  end

  describe "#to_a" do

    let(:data) do
      [
        { "a" => 1, "b" => 2, "c" => 3 }
      ]
    end

    it "returns the array" do
      expect(subject.to_a).to eq [Dummy.new(a: 1, b: 2, c: 3)]
    end

  end

end
