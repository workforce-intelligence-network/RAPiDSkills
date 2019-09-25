require 'rails_helper'

RSpec.describe Occupation, type: :model do
  it "has a valid factory" do
    o = build(:occupation)
    expect(o.valid?).to be true
  end

  it "has unique rapids_code" do
    o = create(:occupation)
    new_o = build(:occupation, rapids_code: o.rapids_code)
    expect(new_o.valid?).to be false
  end

  it "has many industries" do
    industry = create(:industry)
    os = create(:occupation_standard, industry: industry)
    expect(os.occupation.industries).to eq [industry]
  end
end
