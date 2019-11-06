require 'rails_helper'

RSpec.describe API::V1::SessionsController, type: :request do
  describe "POST #create" do
    let(:path) { "/v1/sessions" }

    before do
      allow(User).to receive(:new_token).and_return("abc123")
      allow(JsonWebToken).to receive(:encode).and_return("jwt456")
    end

    context "with valid params" do
      let(:user) { create(:user) }
      let(:params) {
        {
          data: {
            type: "sessions",
            attributes: {
              email: user.email,
              password: user.password,
            }
          }
        }
      }

      it "creates client_session record" do
        expect{
          post path, params: params
        }.to change(user.client_sessions, :count).by(1)
        client_session = ClientSession.last
        expect(client_session.identifier).to eq "abc123"
      end

      it "returns access token" do
        post path, params: params
        expect(response).to have_http_status(:created)
        expect(json["meta"]["access_token"]).to eq "jwt456"
        expect(json["meta"]["token_type"]).to eq "Bearer"
      end
    end

    context "with invalid params" do
      shared_examples "fails" do
        it "does not create client_session record" do
          expect{
            post path, params: params
          }.to_not change(ClientSession, :count)
        end

        it "returns error" do
          post path, params: params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json["errors"][0]["status"]).to eq "422"
          expect(json["errors"][0]["detail"]).to eq "Invalid email or password."
        end
      end

      context "with bad password" do
        it_behaves_like "fails" do
          let(:user) { create(:user) }
          let(:params) {
            {
              data: {
                type: "sessions",
                attributes: {
                  email: user.email,
                  password: "badpassword",
                }
              }
            }
          }
        end
      end

      context "with non-existent email" do
        it_behaves_like "fails" do
          let(:params) {
            {
              data: {
                type: "sessions",
                attributes: {
                  email: "foo@example.com",
                  password: "supersecret",
                }
              }
            }
          }
        end
      end
    end
  end

  describe "DELETE #destroy" do
    let(:user) { create(:user) }
    let(:path) { "/v1/sessions" }
    let(:params) { {} }
    let!(:header) { auth_header(user) }

    it_behaves_like "authorization", :delete

    it "deletes client_session record" do
      expect{
        delete path, headers: header
      }.to change(user.client_sessions, :count).by(-1)
    end

    it "returns no content" do
      delete path, headers: header
      expect(response).to have_http_status(:no_content)
      delete path, headers: header
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
