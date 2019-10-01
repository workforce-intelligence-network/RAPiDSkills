require 'rails_helper'

RSpec.describe Industry, type: :model do
  it "has a valid factory" do
    industry = build(:industry)
    expect(industry.valid?).to be true
  end
end
