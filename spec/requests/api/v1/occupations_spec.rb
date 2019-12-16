require 'rails_helper'

RSpec.describe API::V1::OccupationsController, type: :request do
  describe "GET #index" do
    let!(:occupation1) { create(:occupation, title: "Foo Bar") }
    let!(:occupation2) { create(:occupation, title: "Bar Baz") }
    let!(:occupation3) { create(:occupation, title: "Moo Bar", title_aliases: ["Foo", "Mar"]) }
    let(:path) { "/api/v1/occupations" }

    it "returns the correct data" do
      # With no search parameters, returns all data
      get path
      expect(response).to have_http_status(:success)
      expect(json["data"].count).to eq 3
      expect(json["data"][0]["id"]).to eq occupation2.id.to_s
      expect(json["data"][0]["type"]).to eq "occupation"
      expect(json["data"][0]["attributes"]["title"]).to eq "Bar Baz"
      expect(json["data"][0]["attributes"]["title_aliases"]).to eq ""
      expect(json["data"][1]["id"]).to eq occupation1.id.to_s
      expect(json["data"][1]["type"]).to eq "occupation"
      expect(json["data"][1]["attributes"]["title"]).to eq "Foo Bar"
      expect(json["data"][1]["attributes"]["title_aliases"]).to eq ""
      expect(json["data"][2]["id"]).to eq occupation3.id.to_s
      expect(json["data"][2]["type"]).to eq "occupation"
      expect(json["data"][2]["attributes"]["title"]).to eq "Moo Bar"
      expect(json["data"][2]["attributes"]["title_aliases"]).to eq "Foo, Mar"

      # With search query, returns matches
      get path, params: { q: "Foo" }
      expect(response).to have_http_status(:success)
      expect(json["data"].count).to eq 2
      expect(json["data"][0]["id"]).to eq occupation1.id.to_s
      expect(json["data"][0]["type"]).to eq "occupation"
      expect(json["data"][0]["attributes"]["title"]).to eq "Foo Bar"
      expect(json["data"][0]["attributes"]["title_aliases"]).to eq ""
      expect(json["data"][1]["id"]).to eq occupation3.id.to_s
      expect(json["data"][1]["type"]).to eq "occupation"
      expect(json["data"][1]["attributes"]["title"]).to eq "Moo Bar"
      expect(json["data"][1]["attributes"]["title_aliases"]).to eq "Foo, Mar"

      get path, params: { q: "Moo Mar" }
      expect(response).to have_http_status(:success)
      expect(json["data"].count).to eq 1
      expect(json["data"][0]["id"]).to eq occupation3.id.to_s
      expect(json["data"][0]["type"]).to eq "occupation"
      expect(json["data"][0]["attributes"]["title"]).to eq "Moo Bar"
      expect(json["data"][0]["attributes"]["title_aliases"]).to eq "Foo, Mar"

      get path, params: { q: "Baz" }
      expect(response).to have_http_status(:success)
      expect(json["data"].count).to eq 1
      expect(json["data"][0]["id"]).to eq occupation2.id.to_s
      expect(json["data"][0]["type"]).to eq "occupation"
      expect(json["data"][0]["attributes"]["title"]).to eq "Bar Baz"
      expect(json["data"][0]["attributes"]["title_aliases"]).to eq ""

      # With bad search parameters, returns no data
      get path, params: { q: "Fob" }
      expect(response).to have_http_status(:success)
      expect(json["data"]).to be_empty
    end
  end
end
