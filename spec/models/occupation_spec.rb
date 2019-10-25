require 'rails_helper'

RSpec.describe Occupation, type: :model do
  it "has a valid factory" do
    o = build(:occupation)
    expect(o.valid?).to be true
  end

  it "has unique rapids_code" do
    o = create(:occupation)
    new_o = build(:occupation, rapids_code: o.rapids_code)
    expect(new_o.valid?).to be false
  end

  it "has many industries" do
    industry = create(:industry)
    os = create(:occupation_standard, industry: industry)
    expect(os.occupation.industries).to eq [industry]
  end

  describe ".search" do
    let!(:occupation1) { create(:occupation, title: "Foo Bar") }
    let!(:occupation2) { create(:occupation, title: "Bar Baz") }
    let!(:occupation3) { create(:occupation, title: "Moo Bar", title_aliases: ["Mar", "Foo"]) }

    it "returns all results when q is blank" do
      results = Occupation.search(nil)
      expect(results).to contain_exactly occupation1, occupation2, occupation3

      results = Occupation.search("")
      expect(results).to contain_exactly occupation1, occupation2, occupation3
    end

    it "returns matched results when q is not blank" do
      results = Occupation.search("Foo")
      expect(results).to contain_exactly occupation1, occupation3

      results = Occupation.search("Mar")
      expect(results).to contain_exactly occupation3

      results = Occupation.search("Baz")
      expect(results).to contain_exactly occupation2
    end

    it "returns OR matched results when q has multiple terms" do
      results = Occupation.search("Baz Fob")
      expect(results).to contain_exactly occupation2

      results = Occupation.search("Foo Mar")
      expect(results).to contain_exactly occupation1, occupation3
    end

    it "returns no results when q does not match" do
      results = Occupation.search("Fob")
      expect(results).to be_empty
    end
  end
end
