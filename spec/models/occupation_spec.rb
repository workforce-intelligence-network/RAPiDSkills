require 'rails_helper'

RSpec.describe Occupation, type: :model do
  it "has a valid factory" do
    o = build(:occupation)
    expect(o.valid?).to be true
  end
end
