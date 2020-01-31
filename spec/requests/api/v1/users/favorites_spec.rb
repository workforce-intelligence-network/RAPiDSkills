require 'rails_helper'

RSpec.describe API::V1::Users::FavoritesController, type: :request do
  describe "GET #index" do
    let(:path) { "/api/v1/users/#{user.id}/favorites" }
    let(:user) { create(:user) }
    let(:header) { auth_header(user) }
    let(:params) { {} }

    context "when user viewing own favorites" do
      let(:os1) { create(:occupation_standard) }
      let(:os2) { create(:occupation_standard) }

      before { user.favorites << os1 << os2 }

      it_behaves_like "authorization", :get

      it "returns favorites by most recently added" do
        get path, headers: header
        expect(response).to have_http_status(:success)
        expect(json["links"]["self"]).to eq api_v1_user_favorites_url(user)
        expect(json["data"][0]["type"]).to eq "occupation_standard"
        expect(json["data"][0]["id"]).to eq os2.id.to_s
        expect(json["data"][0]["attributes"]["title"]).to eq os2.title
        expect(json["data"][0]["attributes"]["organization_title"]).to eq os2.organization.title
        expect(json["data"][0]["attributes"]["occupation_title"]).to eq os2.occupation.title
        expect(json["data"][0]["attributes"]["industry_title"]).to be nil
        expect(json["data"][0]["links"]["self"]).to eq api_v1_occupation_standard_url(os2)

        expect(json["data"][1]["type"]).to eq "occupation_standard"
        expect(json["data"][1]["id"]).to eq os1.id.to_s
        expect(json["data"][1]["type"]).to eq "occupation_standard"
        expect(json["data"][1]["attributes"]["title"]).to eq os1.title
        expect(json["data"][1]["attributes"]["organization_title"]).to eq os1.organization.title
        expect(json["data"][1]["attributes"]["occupation_title"]).to eq os1.occupation.title
        expect(json["data"][1]["attributes"]["industry_title"]).to be nil
        expect(json["data"][1]["links"]["self"]).to eq api_v1_occupation_standard_url(os1)
      end
    end

    context "when user viewing own favorites with filter" do
      let(:path) { api_v1_user_favorites_url(user, filter: { creator: user.id }) }
      let(:os1) { create(:occupation_standard) }
      let(:os2) { create(:occupation_standard, creator: user) }

      before { user.favorites << os1 << os2 }

      it_behaves_like "authorization", :get

      it "returns favorites by filtered creator" do
        get path, headers: header
        expect(response).to have_http_status(:success)
        expect(json["links"]["self"]).to eq api_v1_user_favorites_url(user, filter: { creator: user.id})
        expect(json["data"].count).to eq 1
        expect(json["data"][0]["type"]).to eq "occupation_standard"
        expect(json["data"][0]["id"]).to eq os2.id.to_s
        expect(json["data"][0]["attributes"]["title"]).to eq os2.title
        expect(json["data"][0]["attributes"]["organization_title"]).to eq os2.organization.title
        expect(json["data"][0]["attributes"]["occupation_title"]).to eq os2.occupation.title
        expect(json["data"][0]["attributes"]["industry_title"]).to be nil
        expect(json["data"][0]["links"]["self"]).to eq api_v1_occupation_standard_url(os2)
      end
    end

    context "when user viewing someone else's favorites" do
      it_behaves_like "forbidden", :get do
        let(:header) { auth_header(create(:user)) }
      end
    end

    context "when requesting non-existent user" do
      it_behaves_like "not found", :get do
        let(:path) { "/api/v1/users/999/favorites" }
      end
    end
  end
end
