require 'rails_helper'

RSpec.describe API::V1::Sessions::UserController, type: :request do
  describe "GET #show" do
    let(:path) { "/api/v1/sessions/#{cs.id}/user" }
    let(:cs) { create(:client_session) }
    let(:user) { cs.user }
    let(:params) { {} }
    let(:header) { auth_header(user) }
    let(:os) { create(:occupation_standard) }

    context "when session belongs to user" do
      before { user.favorites << os }

      it_behaves_like "authorization", :get

      it "returns the correct data" do
        get path, headers: header
        expect(response).to have_http_status(:success)
        expect(json["links"]["self"]).to eq api_v1_client_session_user_url(cs)
        expect(json["data"]["type"]).to eq "user"
        expect(json["data"]["id"]).to eq user.id.to_s
        expect(json["data"]["attributes"]["email"]).to eq user.email
        expect(json["data"]["attributes"]["name"]).to eq user.name
        expect(json["data"]["attributes"]["role"]).to eq "basic"
        expect(json["data"]["relationships"]["employer"]["data"]).to be nil
        expect(json["data"]["relationships"]["favorites"]["data"].count).to eq 1
        expect(json["data"]["relationships"]["favorites"]["data"][0]["type"]).to eq "occupation_standard"
        expect(json["data"]["relationships"]["favorites"]["data"][0]["id"]).to eq os.id.to_s
        expect(json["data"]["relationships"]["favorites"]["links"]["self"]).to eq relationships_favorites_api_v1_user_url(user)
        expect(json["data"]["relationships"]["favorites"]["links"]["related"]).to eq api_v1_user_favorites_url(user)
      end
    end

    context "when session does not belong to user" do
      it_behaves_like "unauthorized", :get do
        let(:header) { auth_header(create(:user)) }
      end
    end
  end
end
