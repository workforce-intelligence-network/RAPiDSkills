require 'rails_helper'

RSpec.describe OccupationStandardSkill, type: :model do
  it "has a valid factory" do
    oss = build(:occupation_standard_skill)
    expect(oss.valid?).to be true
  end

  it "is unique across occupation_standards when work process is nil" do
    oss = create(:occupation_standard_skill, occupation_standard_work_process: nil)
    oss_new = build(:occupation_standard_skill, occupation_standard: oss.occupation_standard, skill: oss.skill, occupation_standard_work_process: nil)
    expect(oss_new.valid?).to be false
  end

  it "is unique across occupation_standard, work process when work process is not nil" do
    oss = create(:occupation_standard_skill)
    oss_new = build(:occupation_standard_skill,
                    occupation_standard: oss.occupation_standard,
                    skill: oss.skill,
                    occupation_standard_work_process: oss.occupation_standard_work_process,
                   )
    expect(oss_new.valid?).to be false

    oss_new = build(:occupation_standard_skill,
                    occupation_standard: oss.occupation_standard,
                    skill: oss.skill,
                    occupation_standard_work_process: nil,
                   )
    expect(oss_new.valid?).to be true
  end

  describe ".search_records" do
    let!(:skill1) { create(:skill, description: "Fig Berry") }
    let!(:skill2) { create(:skill, description: "Berry Chocolate") }
    let!(:skill3) { create(:skill, description: "Ginger Blueberry") }
    let!(:skill4) { create(:skill, description: "Berry Test") }
    let!(:oss1a) { create(:occupation_standard_skill, skill: skill1) }
    let!(:oss1b) { create(:occupation_standard_skill, skill: skill1) }
    let!(:oss2a) { create(:occupation_standard_skill, skill: skill2) }
    let!(:oss2b) { create(:occupation_standard_skill, skill: skill2) }
    let!(:oss3a) { create(:occupation_standard_skill, skill: skill3) }
    let!(:oss3b) { create(:occupation_standard_skill, skill: skill3) }
    let!(:os) { create(:unregistered_occupation_standard) }
    let!(:oss4) { create(:occupation_standard_skill, skill: skill4, occupation_standard: os) }

    before { Skill.reindex }

    it "returns all results when q is blank" do
      results = OccupationStandardSkill.search_records(q: nil)
      expect(results.map(&:id)).to contain_exactly oss2a.id, oss1a.id, oss3a.id

      results = OccupationStandardSkill.search_records(q: "")
      expect(results.map(&:id)).to contain_exactly oss2a.id, oss1a.id, oss3a.id
    end

    it "returns matched results when q is not blank" do
      results = OccupationStandardSkill.search_records(q: "Fig")
      expect(results.map(&:id)).to contain_exactly oss1a.id

      results = OccupationStandardSkill.search_records(q: "Berry")
      expect(results.map(&:id)).to contain_exactly oss1a.id, oss2a.id
    end

    it "returns OR matched results when q has multiple terms" do
      results = OccupationStandardSkill.search_records(q: "Chocolate Fob")
      expect(results.map(&:id)).to contain_exactly oss2a.id
    end

    it "returns no results when q does not match" do
      results = OccupationStandardSkill.search_records(q: "Fob")
      expect(results).to be_empty
    end

    it "returns partial match for description" do
      results = OccupationStandardSkill.search_records(q: "Choco")
      expect(results.map(&:id)).to contain_exactly oss2a.id
    end
  end
end
