require 'rails_helper'

RSpec.describe ClientSession, type: :model do
  it "has a valid factory" do
    client_session = build(:client_session)
    expect(client_session.valid?).to be true
  end
end
