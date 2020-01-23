require 'rails_helper'

RSpec.describe Relationship, type: :model do
  it "has a valid factory" do
    r = build(:relationship)
    expect(r.valid?).to be true
  end
end
