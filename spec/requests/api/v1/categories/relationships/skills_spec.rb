require 'rails_helper'

RSpec.describe API::V1::Categories::Relationships::SkillsController, type: :request do
  describe "GET #index" do
    let(:path) { "/api/v1/categories/#{category.id}/relationships/skills" }
    let(:category) { create(:category) }
    let(:os) { create(:occupation_standard) }
    let(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }
    let!(:oss1) { create(:occupation_standard_skill, occupation_standard_work_process: oswp, category: category, sort_order: 2) }
    let!(:oss2) { create(:occupation_standard_skill, occupation_standard_work_process: oswp, category: category, sort_order: 1) }
    let!(:oss3) { create(:occupation_standard_skill, occupation_standard_work_process: oswp, sort_order: 1) }

    context "with valid category id" do
      it "returns the correct data" do
        get path
        expect(response).to have_http_status(:success)
        expect(json["links"]["self"]).to eq relationships_skills_api_v1_category_url(category)
        expect(json["links"]["related"]).to eq api_v1_category_occupation_standard_skills_url(category)
        expect(json["data"].count).to eq 2
        expect(json["data"][0]["type"]).to eq "skill"
        expect(json["data"][0]["id"]).to eq oss2.id.to_s
        expect(json["data"][1]["type"]).to eq "skill"
        expect(json["data"][1]["id"]).to eq oss1.id.to_s
      end
    end

    context "with bad category id" do
      it_behaves_like "no content", :get do
        let(:path) { "/api/v1/categories/999/relationships/skills" }
        let(:params) { {} }
        let(:header) { {} }
      end
    end
  end
end
