require 'rails_helper'

RSpec.describe API::V1::OccupationStandardWorkProcesses::CategoriesController, type: :request do
  describe "GET #index" do
    let(:path) { "/api/v1/work_processes/#{oswp.id}/categories" }

    let!(:oswp) { create(:occupation_standard_work_process) }
    let!(:cat1) { create(:category, occupation_standard_work_process: oswp, sort_order: 2) }
    let!(:cat2) { create(:category, occupation_standard_work_process: oswp, sort_order: 1) }

    it "returns the correct data" do
      get path
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq api_v1_occupation_standard_work_process_categories_url(oswp)
      expect(json["data"].count).to eq 2
      expect(json["data"][0]["id"]).to eq cat2.id.to_s
      expect(json["data"][0]["type"]).to eq "category"
      expect(json["data"][0]["attributes"]["name"]).to eq cat2.name
      expect(json["data"][0]["attributes"]["sort_order"]).to eq cat2.sort_order
      expect(json["data"][1]["id"]).to eq cat1.id.to_s
      expect(json["data"][1]["type"]).to eq "category"
      expect(json["data"][1]["attributes"]["name"]).to eq cat1.name
      expect(json["data"][1]["attributes"]["sort_order"]).to eq cat1.sort_order
    end
  end
end
