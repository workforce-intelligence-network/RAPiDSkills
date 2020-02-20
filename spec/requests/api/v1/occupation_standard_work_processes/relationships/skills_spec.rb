require 'rails_helper'

RSpec.describe API::V1::OccupationStandardWorkProcesses::Relationships::SkillsController, type: :request do
  describe "GET #index" do
    let(:path) { "/api/v1/work_processes/#{oswp.id}/relationships/skills" }
    let(:os) { create(:occupation_standard) }
    let(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }
    let!(:oss1) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp, sort_order: 2, id: 100) }
    let!(:oss2) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp, sort_order: 1, id: 101) }

    it "returns the correct data" do
      get path
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq relationships_skills_api_v1_occupation_standard_work_process_url(oswp)
      expect(json["links"]["related"]).to eq api_v1_occupation_standard_work_process_occupation_standard_skills_url(oswp)
      expect(json["data"].count).to eq 2
      expect(json["data"][0]["type"]).to eq "skill"
      expect(json["data"][0]["id"]).to eq oss2.id.to_s
      expect(json["data"][1]["type"]).to eq "skill"
      expect(json["data"][1]["id"]).to eq oss1.id.to_s
    end

    context "with bad oswp id" do
      it_behaves_like "not found", :get do
        let(:path) { "/api/v1/work_processes/999/relationships/skills" }
        let(:params) { {} }
        let(:header) { {} }
      end
    end
  end

  describe "DELETE #destroy" do
    let(:path) { "/api/v1/work_processes/#{oswp.id}/relationships/skills" }
    let(:oswp) { create(:occupation_standard_work_process) }
    let(:header) { {} }
    let(:params) { {} }

    context "when guest" do
      it_behaves_like "unauthorized", :delete
    end

    context "when bad work process id" do
      it_behaves_like "not found", :delete do
        let(:user) { create(:user) }
        let(:header) { auth_header(user) }
        let(:path) { "/api/v1/work_processes/9999/relationships/skills" }
      end
    end

    context "when user does not own work process" do
      it_behaves_like "forbidden", :delete do
        let(:user) { create(:user) }
        let(:header) { auth_header(user) }
      end
    end

    context "when user owns work process" do
      let(:user) { create(:user) }
      let(:header) { auth_header(user) }
      let(:os) { create(:occupation_standard, creator: user) }
      let(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }
      let!(:oss1) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp) }
      let!(:oss2) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp) }
      let!(:oss3) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp) }
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
        oswp.reload
        expect(oswp.occupation_standard_skills).to eq [oss2]
      end
    end
  end
end
