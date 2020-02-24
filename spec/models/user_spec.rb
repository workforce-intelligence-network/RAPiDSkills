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

  describe "before_create #set_default_role" do
    it "sets a basic role by default" do
      user = create(:user, role: nil)
      expect(user.role).to eq 'basic'
    end

    it "does not override an explicit role" do
      user = create(:user, role: :lead)
      expect(user.role).to eq 'lead'
    end
  end

  describe "#favorites" do
    it "links through relationships table" do
      user = create(:user)
      os = create(:occupation_standard)
      create(:relationship, occupation_standard: os, user: user)
      expect(user.favorites).to eq [os]
    end
  end

  describe "#create_api_access_token!" do
    let(:user) { build_stubbed(:user) }
    let(:client_session) { build_stubbed(:client_session) }

    before do
      allow(user).to receive(:create_session!).and_return(client_session)
      allow(client_session).to receive(:token).and_return("jwt123")
    end

    it "returns jwt token" do
      jwt = user.create_api_access_token!
      expect(jwt).to eq "jwt123"
    end
  end

  describe "#create_session!" do
    let(:user) { create(:user) }

    it "creates new client_session record" do
      expect{
        user.create_session!
      }.to change(user.client_sessions, :count).by(1)
    end

    it "returns session" do
      expect(user.create_session!).to be_a(ClientSession)
    end
  end

  describe "#destroy_session!" do
    let(:client_session) { create(:client_session) }
    let(:user) { client_session.user }

    it "deletes client session" do
      expect{
        user.destroy_session!(client_session.id)
      }.to change(user.client_sessions, :count).by(-1)
    end
  end
end
