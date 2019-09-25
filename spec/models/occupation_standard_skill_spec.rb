require 'rails_helper'

RSpec.describe OccupationStandardSkill, type: :model do
  it "has a valid factory" do
    oss = build(:occupation_standard_skill)
    expect(oss.valid?).to be true
  end
end
