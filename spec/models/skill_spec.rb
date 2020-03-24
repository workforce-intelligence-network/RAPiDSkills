require 'rails_helper'

RSpec.describe Skill, type: :model do
  it "has a valid factory" do
    skill = build(:skill)
    expect(skill.valid?).to be true
  end

  describe ".search_records" do
    let!(:skill1) { create(:skill, description: "Fig Berry") }
    let!(:skill2) { create(:skill, description: "Berry Chocolate") }
    let!(:skill3) { create(:skill, description: "Ginger Blueberry") }

    before { Skill.reindex }

    it "returns all results when q is blank" do
      results = Skill.search_records(q: nil)
      expect(results).to contain_exactly skill1, skill2, skill3

      results = Skill.search_records(q: "")
      expect(results).to contain_exactly skill1, skill2, skill3
    end

    it "returns matched results when q is not blank" do
      results = Skill.search_records(q: "Fig")
      expect(results).to contain_exactly skill1

      results = Skill.search_records(q: "Berry")
      expect(results).to contain_exactly skill1, skill2
    end

    it "returns OR matched results when q has multiple terms" do
      results = Skill.search_records(q: "Chocolate Fob")
      expect(results).to contain_exactly skill2
    end

    it "returns no results when q does not match" do
      results = Skill.search_records(q: "Fob")
      expect(results).to be_empty
    end

    it "returns partial match for description" do
      results = Skill.search_records(q: "Choco")
      expect(results).to contain_exactly skill2
    end
  end
end
