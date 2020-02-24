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
      it_behaves_like "not found", :get do
        let(:path) { "/api/v1/categories/999/relationships/skills" }
        let(:params) { {} }
        let(:header) { {} }
      end
    end
  end

  describe "DELETE #destroy" do
    let(:path) { "/api/v1/categories/#{cat.id}/relationships/skills" }
    let(:cat) { create(:category) }
    let(:header) { {} }
    let(:params) { {} }

    context "when guest" do
      it_behaves_like "unauthorized", :delete
    end

    context "when bad category" do
      it_behaves_like "not found", :delete do
        let(:user) { create(:user) }
        let(:header) { auth_header(user) }
        let(:path) { "/api/v1/categories/9999/relationships/skills" }
      end
    end

    context "when user does not own category" do
      it_behaves_like "forbidden", :delete do
        let(:user) { create(:user) }
        let(:header) { auth_header(user) }
      end
    end

    context "when user owns category" do
      let(:user) { create(:user) }
      let(:header) { auth_header(user) }
      let(:os) { create(:occupation_standard, creator: user) }
      let(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }
      let(:cat) { create(:category, occupation_standard_work_process: oswp) }
      let!(:oss1) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp, category: cat) }
      let!(:oss2) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp, category: cat) }
      let!(:oss3) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp, category: cat) }
      let!(:oss4) { create(:occupation_standard_skill) }
      let(:params) {
        {
          data: [
            { type: "skill", id: oss1.id },
            { type: "skill", id: oss3.id },
            { type: "skill", id: oss4.id },
          ]
        }
      }

      it_behaves_like "no content", :delete

      it "deletes occupation standard skill records but not skill records, ignoring skills that are not linked" do
        expect{
          delete path, params: params, headers: header
        }.to change(OccupationStandardSkill, :count).by(-2)
          .and change(Skill, :count).by(0)
      end

      it "removes occupation standard skills from association" do
        delete path, params: params, headers: header
        cat.reload
        expect(cat.occupation_standard_skills).to eq [oss2]
      end
    end
  end
end
