require 'rails_helper'

RSpec.describe State, type: :model do
  it "has a valid factory" do
    state = build(:state)
    expect(state.valid?).to be true
  end

  it "has many organizations" do
    organization = create(:organization)
    location = create(:location, organization: organization)
    expect(location.state.organizations).to eq [organization]
  end
end
