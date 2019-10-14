require 'rails_helper'

RSpec.describe Organization, type: :model do
  it "has a valid factory" do
    o = build(:organization)
    expect(o.valid?).to be true
  end

  it "has a unique title" do
    org = create(:organization)
    new_org = build(:organization, title: org.title)
    expect(new_org.valid?).to be false
  end
end
