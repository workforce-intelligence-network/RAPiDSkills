require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET #new" do
    it "has http status success" do
      get "/welcome"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    let(:params) {
      {
        user: { email: "foo@example.com", name: "Mickey Mouse" }
      }
    }

    context "with new email" do
      it "creates new User record" do
        expect {
          post "/welcome", params: params
        }.to change(User, :count).by(1)

        user = User.last
        expect(user.email).to eq "foo@example.com"
        expect(user.name).to eq "Mickey Mouse"
      end

      it "re-renders welcome page" do
        post "/welcome", params: params
        expect(response).to have_http_status(:success)
        expect(response.body).to match "enter your email address"
      end
    end

    context "with email already in use" do
      let!(:user) { create(:user, email: "foo@example.com", name: "Foo Bar") }

      it "does not create new user record" do
        expect {
          post "/welcome", params: params
        }.to_not change(User, :count)

        user.reload
        expect(user.email).to eq "foo@example.com"
        expect(user.name).to eq "Foo Bar"
      end

      it "re-renders welcome page" do
        post "/welcome", params: params
        expect(response).to have_http_status(:success)
        expect(response.body).to match "enter your email address"
      end
    end
  end
end
