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
end
