require 'rails_helper'

RSpec.describe API::V1::OccupationStandards::Relationships::SkillsController, type: :request do

  describe "GET #index" do
    let(:path) { "/api/v1/occupation_standards/#{os.id}/relationships/skills" }
    let(:os) { create(:occupation_standard) }
    let!(:oss1) { create(:occupation_standard_skill, occupation_standard: os, sort_order: 2, occupation_standard_work_process: nil) }
    let!(:oss2) { create(:occupation_standard_skill, occupation_standard: os, sort_order: 1, occupation_standard_work_process: nil) }
    let!(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }
    let!(:oss3) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp) }

    it "returns the correct data" do
      get path
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq relationships_skills_api_v1_occupation_standard_url(os)
      expect(json["links"]["related"]).to eq api_v1_occupation_standard_occupation_standard_skills_url(os)
      expect(json["data"].count).to eq 2
      expect(json["data"][0]["type"]).to eq "skill"
      expect(json["data"][0]["id"]).to eq oss2.id.to_s
      expect(json["data"][1]["type"]).to eq "skill"
      expect(json["data"][1]["id"]).to eq oss1.id.to_s
    end
  end

  describe "DELETE #destroy" do
    let(:path) { "/api/v1/occupation_standards/#{os.id}/relationships/skills" }
    let(:os) { create(:occupation_standard) }
    let(:header) { {} }
    let(:params) { {} }

    context "when guest" do
      it_behaves_like "unauthorized", :delete
    end

    context "when user does not own occupation standard" do
      it_behaves_like "forbidden", :delete do
        let(:user) { create(:user) }
        let(:header) { auth_header(user) }
      end
    end

    context "when user owns occupation standard" do
      let(:user) { create(:user) }
      let(:os) { create(:occupation_standard, creator: user) }
      let(:header) { auth_header(user) }
      let!(:oss1) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: nil) }
      let!(:oss2) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: nil) }
      let!(:oss3) { create(:occupation_standard_skill, occupation_standard: os) }
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

      it "triggers pdf/excel generation" do
        expect(GenerateOccupationStandardPdfJob).to receive(:perform_later).with(os.id)
        expect(GenerateOccupationStandardExcelJob).to receive(:perform_later).with(os.id)
        delete path, params: params, headers: header
      end

      it "removes occupation standard skills from association" do
        delete path, params: params, headers: header
        os.reload
        expect(os.occupation_standard_skills).to eq [oss2]
      end
    end
  end
end
