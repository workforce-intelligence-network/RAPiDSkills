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
end
