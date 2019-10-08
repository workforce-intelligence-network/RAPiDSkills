require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  it "has a valid factory" do
    admin = build(:admin_user)
    expect(admin.valid?).to be true
  end
end
