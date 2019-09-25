require 'rails_helper'

RSpec.describe Location, type: :model do
  it "has a valid factory" do
    l = build(:location)
    expect(l.valid?).to be true
  end
end
