require 'rails_helper'

RSpec.describe API::V1::UsersController, type: :request do
  describe "POST #create" do
    let(:path) { "/api/v1/users" }

    context "with valid params" do
      let(:params) {
        {
          data: {
            type: "user",
            attributes: {
              email: "foo@Example.com",
              password: "supersecret",
              name: "Mickey Mouse",
              organization_title: "Acme Computing",
            }
          }
        }
      }

      it "create a client_session record" do
        expect{
          post path, params: params
        }.to change(ClientSession, :count).by(1)
      end

      it "returns session data with access token" do
        post path, params: params
        expect(response).to have_http_status(:created)
        expect(json["data"]["relationships"]["sessions"]["data"][0]["id"]).to be
        expect(json["data"]["relationships"]["sessions"]["data"][0]["type"]).to eq "session"
        expect(json["meta"]["access_token"]).to be
        expect(json["meta"]["token_type"]).to eq "Bearer"
      end

      context "with existing user" do
        let!(:user) { create(:user, email: "foo@example.com") }

        context "with no existing sign in" do
          it "updates the User record and signs in" do
            expect(user.sign_in_count).to eq 0
            post path, params: params
            user.reload
            expect(user.sign_in_count).to eq 1
            expect(user.name).to eq "Mickey Mouse"
          end
        end

        context "with an existing sign in" do
          before(:each) { allow_any_instance_of(User).to receive(:joined?).and_return(true) }

          it "doesn't update the User record or sign in" do
            expect(user.sign_in_count).to eq 0
            post path, params: params
            user.reload
            expect(user.sign_in_count).to eq 0
            expect(user.name).to eq user.name
          end
        end
      end

      context "with existing organization" do
        let!(:organization) { create(:organization, title: "Acme Computing") }

        it "creates new User record" do
          expect {
            post path, params: params
          }.to change(User, :count).by(1)

          user = User.last
          expect(user.email).to eq "foo@example.com"
          expect(user.name).to eq "Mickey Mouse"
          expect(user.employer).to eq organization
          expect(user.basic?).to be true
          expect(user.valid_password?("supersecret")).to be true
        end

        it "returns user resource" do
          post path, params: params
          user = User.last
          expect(response).to have_http_status(:created)
          expect(json["data"]["id"]).to eq user.id.to_s
          expect(json["data"]["type"]).to eq "user"
          expect(json["data"]["attributes"]["email"]).to eq "foo@example.com"
          expect(json["data"]["attributes"]["name"]).to eq "Mickey Mouse"
          expect(json["data"]["attributes"]["role"]).to eq "basic"
          expect(json["data"]["relationships"]["employer"]["data"]["id"]).to eq organization.id.to_s
          expect(json["data"]["relationships"]["employer"]["data"]["type"]).to eq "organization"
          expect(json["included"]).to include(a_hash_including("id" => organization.id.to_s, "type" => "organization"))
        end
      end

      context "with new organization" do
        let(:params) {
          {
            data: {
              type: "user",
              attributes: {
                email: "foo@example.com",
                password: "supersecret",
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
          organization = Organization.last
          expect(response).to have_http_status(:created)
          expect(json["data"]["id"]).to eq user.id.to_s
          expect(json["data"]["type"]).to eq "user"
          expect(json["data"]["attributes"]["email"]).to eq "foo@example.com"
          expect(json["data"]["attributes"]["name"]).to eq "Mickey Mouse"
          expect(json["data"]["attributes"]["role"]).to eq "basic"
          expect(json["data"]["relationships"]["employer"]["data"]["id"]).to eq organization.id.to_s
          expect(json["data"]["relationships"]["employer"]["data"]["type"]).to eq "organization"
          expect(json["included"]).to include(a_hash_including("id" => organization.id.to_s, "type" => "organization"))
        end
      end

      context "with no organization" do
        let(:params) {
          {
            data: {
              type: "user",
              attributes: {
                email: "foo@example.com",
                password: "supersecret",
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
          expect(response).to have_http_status(:created)
          expect(json["data"]["id"]).to eq user.id.to_s
          expect(json["data"]["type"]).to eq "user"
          expect(json["data"]["attributes"]["email"]).to eq "foo@example.com"
          expect(json["data"]["attributes"]["name"]).to eq "Mickey Mouse"
          expect(json["data"]["attributes"]["role"]).to eq "basic"
          expect(json["data"]["relationships"]["employer"]["data"]).to be nil
        end
      end
    end

    context "with invalid params" do
      context "without email" do
        let(:params) {
          {
            data: {
              type: "user",
              attributes: {
                email: "",
                password: "supersecret",
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

      context "when missing attributes data" do
        let(:params) {
          {
            data: {
              type: "user",
              attributes: {
              }
            }
          }
        }

        it "returns 422 http status" do
          post path, params: params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json["errors"][0]["status"]).to eq "422"
          expect(json["errors"][0]["detail"]).to match "empty: attributes"
        end
      end
    end
  end
end
