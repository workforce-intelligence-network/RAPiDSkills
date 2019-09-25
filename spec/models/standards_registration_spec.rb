require 'rails_helper'

RSpec.describe StandardsRegistration, type: :model do
  it "has a valid factory" do
    sr = build(:standards_registration)
    expect(sr.valid?).to be true
  end
end
