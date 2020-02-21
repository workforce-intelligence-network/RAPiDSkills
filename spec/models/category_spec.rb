require 'rails_helper'

RSpec.describe Category, type: :model do
  it "has a valid factory" do
    category = build(:category)
    expect(category.valid?).to be true
  end

  it "has a unique name across work process" do
    category = create(:category)
    new_cat = build(:category, name: category.name, occupation_standard_work_process: category.occupation_standard_work_process)
    expect(new_cat.valid?).to be false
    new_cat.name = "different"
    expect(new_cat.save).to be true
  end
end
