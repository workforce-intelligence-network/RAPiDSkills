require 'rails_helper'

RSpec.describe OccupationStandardWorkProcess, type: :model do
  it "has a valid factory" do
    oswp = build(:occupation_standard_work_process)
    expect(oswp.valid?).to be true
  end

  it "is unique across occupation_standards" do
    oswp = create(:occupation_standard_work_process)
    oswp_new = build(:occupation_standard_work_process, occupation_standard: oswp.occupation_standard, work_process: oswp.work_process)
    expect(oswp_new.valid?).to be false
  end
end
