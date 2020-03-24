require 'rails_helper'

RSpec.describe API::V1::OccupationsController, type: :request do
  describe "GET #index" do
    let!(:occupation1) { create(:occupation, title: "Fig Berry") }
    let!(:occupation2) { create(:occupation, title: "Berry Chocolate") }
    let!(:occupation3) { create(:occupation, title: "Ginger Berry", title_aliases: ["Fig", "Mar"]) }
    let(:path) { "/api/v1/occupations" }

    before { Occupation.reindex }

    it "returns the correct data" do
      # With no search parameters, returns all data
      get path
      expect(response).to have_http_status(:success)
      expect(json["data"].count).to eq 3
      expect(json["data"][0]["id"]).to eq occupation1.id.to_s
      expect(json["data"][0]["type"]).to eq "occupation"
      expect(json["data"][0]["attributes"]["title"]).to eq "Fig Berry"
      expect(json["data"][0]["attributes"]["title_aliases"]).to eq ""
      expect(json["data"][1]["id"]).to eq occupation2.id.to_s
      expect(json["data"][1]["type"]).to eq "occupation"
      expect(json["data"][1]["attributes"]["title"]).to eq "Berry Chocolate"
      expect(json["data"][1]["attributes"]["title_aliases"]).to eq ""
      expect(json["data"][2]["id"]).to eq occupation3.id.to_s
      expect(json["data"][2]["type"]).to eq "occupation"
      expect(json["data"][2]["attributes"]["title"]).to eq "Ginger Berry"
      expect(json["data"][2]["attributes"]["title_aliases"]).to eq "Fig, Mar"

      # With search query, returns matches
      get path, params: { q: "Fig" }
      expect(response).to have_http_status(:success)
      expect(json["data"].count).to eq 2
      expect(json["data"][0]["id"]).to eq occupation1.id.to_s
      expect(json["data"][0]["type"]).to eq "occupation"
      expect(json["data"][0]["attributes"]["title"]).to eq "Fig Berry"
      expect(json["data"][0]["attributes"]["title_aliases"]).to eq ""
      expect(json["data"][1]["id"]).to eq occupation3.id.to_s
      expect(json["data"][1]["type"]).to eq "occupation"
      expect(json["data"][1]["attributes"]["title"]).to eq "Ginger Berry"
      expect(json["data"][1]["attributes"]["title_aliases"]).to eq "Fig, Mar"

      get path, params: { q: "Ginger Mar" }
      expect(response).to have_http_status(:success)
      expect(json["data"].count).to eq 1
      expect(json["data"][0]["id"]).to eq occupation3.id.to_s
      expect(json["data"][0]["type"]).to eq "occupation"
      expect(json["data"][0]["attributes"]["title"]).to eq "Ginger Berry"
      expect(json["data"][0]["attributes"]["title_aliases"]).to eq "Fig, Mar"

      get path, params: { q: "Chocolate" }
      expect(response).to have_http_status(:success)
      expect(json["data"].count).to eq 1
      expect(json["data"][0]["id"]).to eq occupation2.id.to_s
      expect(json["data"][0]["type"]).to eq "occupation"
      expect(json["data"][0]["attributes"]["title"]).to eq "Berry Chocolate"
      expect(json["data"][0]["attributes"]["title_aliases"]).to eq ""

      # With bad search parameters, returns no data
      get path, params: { q: "Fob" }
      expect(response).to have_http_status(:success)
      expect(json["data"]).to be_empty
    end
  end
end
