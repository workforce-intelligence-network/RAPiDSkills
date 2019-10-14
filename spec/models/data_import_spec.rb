require 'rails_helper'

RSpec.describe DataImport, type: :model do
  it "has a valid factory" do
    data_import = build(:data_import)
    expect(data_import.valid?).to be true
  end
end
