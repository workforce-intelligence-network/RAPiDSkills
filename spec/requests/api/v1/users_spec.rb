require 'rails_helper'

RSpec.describe API::V1::UsersController, type: :request do
  describe "POST #create" do
    let(:path) { "/v1/users" }
    let(:params) {
      {
        data: {
          type: "users",
          attributes: {
            email: "foo@example.com",
            name: "Mickey Mouse",
          }
        }
      }
    }

    before { allow(SecureRandom).to receive(:uuid).and_return("password") }

    context "with valid params" do
      context "with new email" do
        it "creates new User record" do
          expect {
            post path, params: params
          }.to change(User, :count).by(1)

          user = User.last
          expect(user.email).to eq "foo@example.com"
          expect(user.name).to eq "Mickey Mouse"
          expect(user.valid_password?("password")).to be true
        end

        it "returns user resource" do
          post path, params: params
          user = User.last
          expect(response).to have_http_status(:success)
          expect(json["data"]["id"]).to eq user.id.to_s
          expect(json["data"]["type"]).to eq "user"
          expect(json["data"]["attributes"]["email"]).to eq "foo@example.com"
          expect(json["data"]["attributes"]["name"]).to eq "Mickey Mouse"
        end
      end

      context "with email already in use" do
        let!(:user) { create(:user, email: "foo@example.com", name: "Foo Bar") }

        it "does not create new user record but updates user" do
          expect {
            post path, params: params
          }.to_not change(User, :count)

          user.reload
          expect(user.email).to eq "foo@example.com"
          expect(user.name).to eq "Mickey Mouse"
          expect(user.valid_password?("supersecret")).to be true
        end

        it "returns user resource" do
          post path, params: params
          user = User.last
          expect(response).to have_http_status(:success)
          expect(json["data"]["id"]).to eq user.id.to_s
          expect(json["data"]["type"]).to eq "user"
          expect(json["data"]["attributes"]["email"]).to eq "foo@example.com"
          expect(json["data"]["attributes"]["name"]).to eq "Mickey Mouse"
        end
      end
    end

    context "with invalid params" do
      context "without email" do
        let(:params) {
          {
            data: {
              type: "users",
              attributes: {
                email: "",
                name: "Mickey Mouse",
              }
            }
          }
        }

        it "does not create new User record" do
          expect {
            post path, params: params
          }.to_not change(User, :count)
        end

        it "returns 422 with error message" do
          post path, params: params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json["errors"].count).to eq 1
          expect(json["errors"][0]["status"]).to eq "422"
          expect(json["errors"][0]["detail"]).to eq "Email can't be blank"
        end
      end
    end
  end
end
