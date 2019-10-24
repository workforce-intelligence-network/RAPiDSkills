require 'rails_helper'

RSpec.describe API::V1::OccupationsController, type: :request do
  describe "GET #index" do
    let!(:occupation1) { create(:occupation, title: "Foo Bar") }
    let!(:occupation2) { create(:occupation, title: "Bar Baz") }
    let!(:occupation3) { create(:occupation, title: "Moo Bar", title_aliases: ["Foo", "Mar"]) }
    let(:path) { "/v1/occupations" }

    it "returns the correct data" do
      # With no search parameters, returns no data
      get path
      expect(response).to have_http_status(:success)
      expect(json["payload"]).to be_empty

      # With search query, returns matches
      get path, params: { q: "Foo" }
      expect(response).to have_http_status(:success)
      expect(json["payload"].count).to eq 2
      expect(json["payload"][0]["id"]).to eq occupation3.id
      expect(json["payload"][0]["title"]).to eq "Moo Bar"
      expect(json["payload"][0]["title_aliases"]).to eq "Foo, Mar"
      expect(json["payload"][1]["id"]).to eq occupation1.id
      expect(json["payload"][1]["title"]).to eq "Foo Bar"
      expect(json["payload"][1]["title_aliases"]).to be_empty

      get path, params: { q: "Foo Bar" }
      expect(response).to have_http_status(:success)
      expect(json["payload"].count).to eq 1
      expect(json["payload"][0]["id"]).to eq occupation1.id
      expect(json["payload"][0]["title"]).to eq "Foo Bar"
      expect(json["payload"][0]["title_aliases"]).to be_empty

      get path, params: { q: "Baz" }
      expect(response).to have_http_status(:success)
      expect(json["payload"].count).to eq 1
      expect(json["payload"][0]["id"]).to eq occupation2.id
      expect(json["payload"][0]["title"]).to eq "Bar Baz"
      expect(json["payload"][0]["title_aliases"]).to be_empty
    end
  end
end
