require 'rails_helper'

RSpec.describe API::V1::OccupationStandards::RelationshipsController, type: :request do
  describe "GET #work_processes" do
    let(:path) { "/api/v1/occupation_standards/#{os.id}/relationships/work_processes" }
    let(:os) { create(:occupation_standard) }
    let!(:oswp1) { create(:occupation_standard_work_process, occupation_standard: os, sort_order: 2) }
    let!(:oswp2) { create(:occupation_standard_work_process, occupation_standard: os, sort_order: 1) }

    it "returns the correct data" do
      get path
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq relationships_work_processes_api_v1_occupation_standard_url(os)
      expect(json["links"]["related"]).to eq api_v1_occupation_standard_work_processes_url(os)
      expect(json["data"].count).to eq 2
      expect(json["data"][0]["type"]).to eq "work_process"
      expect(json["data"][0]["id"]).to eq oswp2.id.to_s
      expect(json["data"][1]["type"]).to eq "work_process"
      expect(json["data"][1]["id"]).to eq oswp1.id.to_s
    end
  end
end
