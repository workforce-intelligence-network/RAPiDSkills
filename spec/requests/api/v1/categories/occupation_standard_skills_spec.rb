require 'rails_helper'

RSpec.describe API::V1::Categories::OccupationStandardSkillsController, type: :request do
  describe "GET #index" do
    let(:path) { "/api/v1/categories/#{category.id}/skills" }

    context "with valid category id" do
      let(:os) { create(:occupation_standard) }
      let!(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }
      let(:category) { create(:category, occupation_standard_work_process: oswp) }
      let!(:oss1) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp, category: category, sort_order: 2, id: 101) }
      let!(:oss2) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp, category: category, sort_order: 1, id: 102) }
      let!(:oss3) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp, category: nil) }

      it "returns the correct data" do
        get path
        expect(response).to have_http_status(:success)
        expect(json["links"]["self"]).to eq api_v1_category_occupation_standard_skills_url(category)
        expect(json["data"].count).to eq 2
        expect(json["data"][0]["id"]).to eq oss2.id.to_s
        expect(json["data"][0]["type"]).to eq "skill"
        expect(json["data"][0]["attributes"]["description"]).to eq oss2.skill.description
        expect(json["data"][1]["id"]).to eq oss1.id.to_s
        expect(json["data"][1]["type"]).to eq "skill"
        expect(json["data"][1]["attributes"]["description"]).to eq oss1.skill.description
      end
    end

    context "with bad category id" do
      it_behaves_like "not found", :get do
        let(:path) { "/api/v1/categories/999/skills" }
        let(:params) { {} }
        let(:header) { {} }
      end
    end
  end
end
