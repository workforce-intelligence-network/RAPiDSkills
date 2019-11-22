require 'rails_helper'

RSpec.describe API::V1::OccupationStandardSkillsController, type: :request do
  describe "GET #index" do
    let(:path) { "/api/v1/occupation_standards/#{os.id}/skills" }

    let(:os) { create(:occupation_standard) }
    let!(:oss1) { create(:occupation_standard_skill, occupation_standard: os, sort_order: 2, occupation_standard_work_process: nil) }
    let!(:oss2) { create(:occupation_standard_skill, occupation_standard: os, sort_order: 1, occupation_standard_work_process: nil) }
    let!(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }
    let!(:oss3) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp) }

    it "returns the correct data" do
      get path
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq api_v1_occupation_standard_occupation_standard_skills_url(os)
      expect(json["data"].count).to eq 2
      expect(json["data"][0]["id"]).to eq oss2.id.to_s
      expect(json["data"][0]["type"]).to eq "skill"
      expect(json["data"][0]["attributes"]["description"]).to eq oss2.skill.description
      expect(json["data"][1]["id"]).to eq oss1.id.to_s
      expect(json["data"][1]["type"]).to eq "skill"
      expect(json["data"][1]["attributes"]["description"]).to eq oss1.skill.description
    end
  end

  describe "GET #show" do
    let(:path) { "/api/v1/skills/#{oss.id}" }

    let(:oss) { create(:occupation_standard_skill) }

    it "returns the correct data" do
      get path
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
      expect(json["data"]["id"]).to eq oss.id.to_s
      expect(json["data"]["type"]).to eq "skill"
      expect(json["data"]["attributes"]["description"]).to eq oss.skill.description
    end
  end
end
