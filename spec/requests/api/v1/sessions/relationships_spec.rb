require 'rails_helper'

RSpec.describe API::V1::Sessions::RelationshipsController, type: :request do
  describe "GET #user" do
    let(:path) { "/api/v1/sessions/#{cs.id}/relationships/user" }
    let(:cs) { create(:client_session) }
    let(:user) { cs.user }
    let(:params) { {} }
    let(:header) { auth_header(user) }

    context "when session belongs to user" do
      it_behaves_like "authentication", :get

      it "returns the correct data" do
        get path, headers: header
        expect(response).to have_http_status(:success)
        expect(json["links"]["self"]).to eq relationships_user_api_v1_client_session_url(cs)
        expect(json["links"]["related"]).to eq api_v1_client_session_user_url(cs)
        expect(json["data"]["type"]).to eq "user"
        expect(json["data"]["id"]).to eq user.id.to_s
      end
    end

    context "when session does not belong to user" do
      it_behaves_like "forbidden", :get do
        let(:header) { auth_header(create(:user)) }
      end
    end
  end
end
