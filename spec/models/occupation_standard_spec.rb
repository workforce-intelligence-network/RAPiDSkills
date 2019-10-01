require 'rails_helper'

RSpec.describe OccupationStandard, type: :model do
  it "has a valid occupation standard" do
    os = build(:occupation_standard)
    expect(os.valid?).to be true
  end
end
