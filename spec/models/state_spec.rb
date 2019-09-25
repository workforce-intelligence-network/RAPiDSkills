require 'rails_helper'

RSpec.describe State, type: :model do
  it "has a valid factory" do
    state = build(:state)
    expect(state.valid?).to be true
  end
end
