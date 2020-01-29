require 'rails_helper'

RSpec.describe API::V1::Users::Relationships::OccupationStandardsController, type: :request do
  describe "GET #index" do
    let(:path) { "/api/v1/users/#{user.id}/relationships/occupation_standards" }
    let(:user) { create(:user) }
    let(:header) { auth_header(user) }
    let(:params) { {} }

    it_behaves_like "authorization", :get

    context "when user requests own occupation_standards" do
      let!(:os) { create(:occupation_standard) }
      let!(:os_list) { create_list(:occupation_standard, 2, creator: user) }

      it "returns list of occupation_standards ordered by most id desc" do
        get path, headers: header
        expect(response).to have_http_status(:success)
        expect(json["links"]["self"]).to eq relationships_occupation_standards_api_v1_user_url(user)
        expect(json["links"]["related"]).to eq api_v1_user_occupation_standards_url(user)
        expect(json["data"][0]["type"]).to eq "occupation_standard"
        expect(json["data"][0]["id"]).to eq os_list.last.id.to_s
        expect(json["data"][1]["type"]).to eq "occupation_standard"
        expect(json["data"][1]["id"]).to eq os_list.first.id.to_s
      end
    end

    context "when user requests someone else's occupation_standards" do
      it_behaves_like "unauthorized", :get do
        let(:header) { auth_header(create(:user)) }
      end
    end

    context "when requesting non-existent user" do
      it_behaves_like "not found", :get do
        let(:path) { "/api/v1/users/999/relationships/occupation_standards" }
      end
    end
  end
end
