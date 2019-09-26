require 'rails_helper'

RSpec.describe OccupationStandardWorkProcess, type: :model do
  it "has a valid factory" do
    oswp = build(:occupation_standard_work_process)
    expect(oswp.valid?).to be true
  end
end
