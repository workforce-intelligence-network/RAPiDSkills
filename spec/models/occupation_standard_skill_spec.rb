require 'rails_helper'

RSpec.describe OccupationStandardSkill, type: :model do
  it "has a valid factory" do
    oss = build(:occupation_standard_skill)
    expect(oss.valid?).to be true
  end

  it "is unique across occupation_standards" do
    oss = create(:occupation_standard_skill)
    oss_new = build(:occupation_standard_skill, occupation_standard: oss.occupation_standard, skill: oss.skill)
    expect(oss_new.valid?).to be false
  end
end
