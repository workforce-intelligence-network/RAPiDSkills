require 'rails_helper'

RSpec.describe API::V1::OccupationStandardWorkProcessesController, type: :request do
  describe "GET #show" do
    let(:path) { "/api/v1/work_processes/#{oswp.id}" }

    let(:os) { create(:occupation_standard) }
    let(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }
    let!(:oss) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp) }

    it "returns the correct data" do
      get path
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq api_v1_occupation_standard_work_process_url(oswp)
      expect(json["data"]["id"]).to eq oswp.id.to_s
      expect(json["data"]["type"]).to eq "work_process"
      expect(json["data"]["attributes"]["title"]).to eq oswp.work_process.title
      expect(json["data"]["attributes"]["description"]).to eq oswp.work_process.description
      expect(json["data"]["relationships"]["skills"]["links"]["self"]).to eq relationships_skills_api_v1_occupation_standard_work_process_url(oswp)
      expect(json["data"]["relationships"]["skills"]["links"]["related"]).to eq api_v1_occupation_standard_work_process_skills_url(oswp)
      expect(json["data"]["relationships"]["skills"]["data"].count).to eq 1
      expect(json["data"]["relationships"]["skills"]["data"][0]["type"]).to eq "skill"
      expect(json["data"]["relationships"]["skills"]["data"][0]["id"]).to eq oss.skill_id.to_s
      expect(json["included"][0]["type"]).to eq "skill"
      expect(json["included"][0]["id"]).to eq oss.skill_id.to_s
      expect(json["included"][0]["attributes"]["description"]).to eq oss.skill.description
    end
  end
end
