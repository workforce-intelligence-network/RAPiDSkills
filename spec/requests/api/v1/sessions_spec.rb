require 'rails_helper'

RSpec.describe API::V1::SessionsController, type: :request do
  describe "POST #create" do
    let(:path) { "/api/v1/sessions" }

    before do
      allow_any_instance_of(ClientSession).to receive(:id).and_return("abc123")
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
      end

      it "returns session data with access token" do
        post path, params: params
        expect(response).to have_http_status(:created)
        expect(json["links"]["self"]).to eq api_v1_client_session_url("abc123")
        expect(json["data"]["type"]).to eq "session"
        expect(json["data"]["id"]).to eq "abc123"
        expect(json["data"]["relationships"]["user"]["links"]["self"]).to eq relationships_user_api_v1_client_session_url("abc123")
        expect(json["data"]["relationships"]["user"]["links"]["related"]).to eq api_v1_client_session_user_url("abc123")
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

  describe "GET #show" do
    let(:path) { "/api/v1/sessions/abc123" }
    let(:user) { create(:user) }
    let!(:client_session) { create(:client_session, id: "abc123", user: user) }
    let(:uuid) { client_session.id }
    let(:token) { JsonWebToken.encode(id: user.id, encrypted_password: user.encrypted_password, session_identifier: uuid) }

    let(:header) { { "HTTP_AUTHORIZATION" => "Bearer #{token}" } }
    let(:params) { {} }

    it_behaves_like "authorization", :get

    it "returns session data" do
      get path, headers: header
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq api_v1_client_session_url(uuid)
      expect(json["data"]["type"]).to eq "session"
      expect(json["data"]["id"]).to eq uuid
      expect(json["data"]["relationships"]["user"]["links"]["self"]).to eq relationships_user_api_v1_client_session_url(uuid)
      expect(json["data"]["relationships"]["user"]["links"]["related"]).to eq api_v1_client_session_user_url(uuid)
      expect(json["meta"]["access_token"]).to eq token
      expect(json["meta"]["token_type"]).to eq "Bearer"
    end
  end

  describe "DELETE #destroy" do
    let(:user) { create(:user) }
    let(:path) { "/api/v1/sessions/abc123" }
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
