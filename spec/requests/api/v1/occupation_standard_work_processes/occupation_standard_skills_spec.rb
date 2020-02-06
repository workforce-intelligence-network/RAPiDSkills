require 'rails_helper'

RSpec.describe API::V1::OccupationStandardWorkProcesses::OccupationStandardSkillsController, type: :request do
  describe "GET #index" do
    let(:path) { "/api/v1/work_processes/#{oswp.id}/skills" }

    let(:os) { create(:occupation_standard) }
    let!(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }
    let!(:oss1) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp, sort_order: 2) }
    let!(:oss2) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp, sort_order: 1) }
    let!(:oss3) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: nil) }

    context "with valid work process id" do
      it "returns the correct data" do
        get path
        expect(response).to have_http_status(:success)
        expect(json["links"]["self"]).to eq api_v1_occupation_standard_work_process_occupation_standard_skills_url(oswp)
        expect(json["data"].count).to eq 2
        expect(json["data"][0]["id"]).to eq oss2.id.to_s
        expect(json["data"][0]["type"]).to eq "skill"
        expect(json["data"][0]["attributes"]["description"]).to eq oss2.skill.description
        expect(json["data"][1]["id"]).to eq oss1.id.to_s
        expect(json["data"][1]["type"]).to eq "skill"
        expect(json["data"][1]["attributes"]["description"]).to eq oss1.skill.description
      end
    end

    context "with bad work process id" do
      it_behaves_like "not found", :get do
        let(:path) { "/api/v1/work_processes/999/skills" }
        let(:params) { {} }
        let(:header) { {} }
      end
    end
  end
end
