require 'rails_helper'

RSpec.describe ClientSession, type: :model do
  it "has a valid factory" do
    client_session = build(:client_session)
    expect(client_session.valid?).to be true
  end

  describe "#create_api_access_token!" do
    let(:client_session) { create(:client_session) }
    let(:user) { client_session.user }

    before do
      allow(JsonWebToken).to receive(:encode).with(id: user.id, encrypted_password: user.encrypted_password, session_identifier: client_session.identifier).and_return("jwt123")
    end

    it "returns jwt token" do
      jwt = client_session.create_api_access_token!
      expect(jwt).to eq "jwt123"
    end
  end
end
