require 'rails_helper'

RSpec.describe Organization, type: :model do
  it "has a valid factory" do
    o = build(:organization)
    expect(o.valid?).to be true
  end
end
