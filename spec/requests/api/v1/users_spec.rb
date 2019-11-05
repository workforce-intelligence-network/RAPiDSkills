require 'rails_helper'

RSpec.describe API::V1::UsersController, type: :request do
  describe "POST #create" do
    let(:path) { "/v1/users" }

    before { allow(SecureRandom).to receive(:uuid).and_return("password") }

    context "with valid params" do
      let(:params) {
        {
          data: {
            type: "users",
            attributes: {
              email: "foo@example.com",
              name: "Mickey Mouse",
              organization_title: "Acme Computing",
            }
          }
        }
      }

      context "with existing organization" do
        let!(:organization) { create(:organization, title: "Acme Computing") }

        context "with new email" do
          it "creates new User record" do
            expect {
              post path, params: params
            }.to change(User, :count).by(1)

            user = User.last
            expect(user.email).to eq "foo@example.com"
            expect(user.name).to eq "Mickey Mouse"
            expect(user.employer).to eq organization
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
            expect(json["data"]["attributes"]["organization_title"]).to eq "Acme Computing"
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
            expect(user.employer).to eq organization
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
            expect(json["data"]["attributes"]["organization_title"]).to eq "Acme Computing"
          end
        end
      end

      context "with new organization" do
        let(:params) {
          {
            data: {
              type: "users",
              attributes: {
                email: "foo@example.com",
                name: "Mickey Mouse",
                organization_title: "Acme Computing",
              }
            }
          }
        }

        it "creates new Organization record" do
          expect {
            post path, params: params
          }.to change(Organization, :count).by(1)

          organization = Organization.last
          expect(organization.title).to eq "Acme Computing"
        end

        it "returns user resource" do
          post path, params: params
          user = User.last
          expect(response).to have_http_status(:success)
          expect(json["data"]["id"]).to eq user.id.to_s
          expect(json["data"]["type"]).to eq "user"
          expect(json["data"]["attributes"]["email"]).to eq "foo@example.com"
          expect(json["data"]["attributes"]["name"]).to eq "Mickey Mouse"
          expect(json["data"]["attributes"]["organization_title"]).to eq "Acme Computing"
        end
      end

      context "with no organization" do
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

        it "does not create new Organization record" do
          expect {
            post path, params: params
          }.to_not change(Organization, :count)
        end

        it "returns user resource" do
          post path, params: params
          user = User.last
          expect(response).to have_http_status(:success)
          expect(json["data"]["id"]).to eq user.id.to_s
          expect(json["data"]["type"]).to eq "user"
          expect(json["data"]["attributes"]["email"]).to eq "foo@example.com"
          expect(json["data"]["attributes"]["name"]).to eq "Mickey Mouse"
          expect(json["data"]["attributes"]["organization_title"]).to be nil
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
