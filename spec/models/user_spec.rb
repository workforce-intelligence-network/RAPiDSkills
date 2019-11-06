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

  describe ".new_token" do
    it "returns url safe base64 string" do
      expect(User.new_token).to be_a(String)
    end
  end

  describe "#create_api_access_token!" do
    let(:user) { create(:user) }

    before do
      allow(User).to receive(:new_token).and_return("id123")
      allow(JsonWebToken).to receive(:encode).with(id: user.id, encrypted_password: user.encrypted_password, session_identifier: "id123").and_return("jwt123")
    end

    it "creates new client_session record" do
      expect{
        user.create_api_access_token!
      }.to change(user.client_sessions, :count).by(1)
    end

    it "sets identifier on client_session record" do
      user.create_api_access_token!
      client_session = user.client_sessions.last
      expect(client_session.identifier).to eq "id123"
    end

    it "returns jwt token" do
      jwt = user.create_api_access_token!
      expect(jwt).to eq "jwt123"
    end
  end
end
