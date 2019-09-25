require 'rails_helper'

RSpec.describe Skill, type: :model do
  it "has a valid factory" do
    skill = build(:skill)
    expect(skill.valid?).to be true
  end
end
