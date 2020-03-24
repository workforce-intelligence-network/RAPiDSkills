require 'rails_helper'

RSpec.describe Occupation, type: :model do
  it "has a valid factory" do
    o = build(:occupation)
    expect(o.valid?).to be true
  end

  describe ".search_records" do
    let!(:occupation1) { create(:occupation, title: "Fig Berry") }
    let!(:occupation2) { create(:occupation, title: "Berry Chocolate") }
    let!(:occupation3) { create(:occupation, title: "Ginger Berry", title_aliases: ["Marshmallow", "Fig"]) }
    let!(:occupation4) { create(:occupation, title: "Acme Computing", onet_code: "12-3456.00") }

    before { Occupation.reindex }

    it "returns all results when q is blank" do
      results = Occupation.search_records(q: nil)
      expect(results).to contain_exactly occupation1, occupation2, occupation3, occupation4

      results = Occupation.search_records(q: "")
      expect(results).to contain_exactly occupation1, occupation2, occupation3, occupation4
    end

    it "returns matched results when q is not blank" do
      results = Occupation.search_records(q: "Fig")
      expect(results).to contain_exactly occupation1, occupation3

      results = Occupation.search_records(q: "Marshmallow")
      expect(results).to contain_exactly occupation3

      results = Occupation.search_records(q: "Chocolate")
      expect(results).to contain_exactly occupation2
    end

    it "returns OR matched results when q has multiple terms" do
      results = Occupation.search_records(q: "Chocolate Fob")
      expect(results).to contain_exactly occupation2

      results = Occupation.search_records(q: "Fig Marshmallow")
      expect(results).to contain_exactly occupation1, occupation3
    end

    it "returns no results when q does not match" do
      results = Occupation.search_records(q: "Fob")
      expect(results).to be_empty
    end

    it "returns partial match for onet code" do
      results = Occupation.search_records(q: "12-34")
      expect(results).to contain_exactly occupation4
    end
  end
end
