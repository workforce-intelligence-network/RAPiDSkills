require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    user = build(:user)
    expect(user.valid?).to be true
  end

  it "has unique email" do
    user = create(:user)
    new_user = build(:user, email: user.email)
    expect(new_user.valid?).to be false
  end
end
