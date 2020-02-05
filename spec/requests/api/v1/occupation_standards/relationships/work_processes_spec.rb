require 'rails_helper'

RSpec.describe API::V1::OccupationStandards::Relationships::WorkProcessesController, type: :request do

  describe "GET #index" do
    let(:path) { "/api/v1/occupation_standards/#{os.id}/relationships/work_processes" }
    let(:os) { create(:occupation_standard) }
    let!(:oswp1) { create(:occupation_standard_work_process, occupation_standard: os, sort_order: 2) }
    let!(:oswp2) { create(:occupation_standard_work_process, occupation_standard: os, sort_order: 1) }

    it "returns the correct data" do
      get path
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq relationships_work_processes_api_v1_occupation_standard_url(os)
      expect(json["links"]["related"]).to eq api_v1_occupation_standard_occupation_standard_work_processes_url(os)
      expect(json["data"].count).to eq 2
      expect(json["data"][0]["type"]).to eq "work_process"
      expect(json["data"][0]["id"]).to eq oswp2.id.to_s
      expect(json["data"][1]["type"]).to eq "work_process"
      expect(json["data"][1]["id"]).to eq oswp1.id.to_s
    end
  end

  describe "DELETE #destroy" do
    let(:path) { "/api/v1/occupation_standards/#{os.id}/relationships/work_processes" }
    let(:os) { create(:occupation_standard) }
    let(:params) { {} }
    let(:header) { {} }

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

      context "when work processes have no skills" do
        let!(:oswp1) { create(:occupation_standard_work_process, occupation_standard: os) }
        let!(:oswp2) { create(:occupation_standard_work_process, occupation_standard: os) }
        let!(:oswp3) { create(:occupation_standard_work_process, occupation_standard: os) }
        let!(:oswp4) { create(:occupation_standard_work_process) }
        let(:params) {
          {
            data: [
              { type: "work_process", id: oswp1.id },
              { type: "work_process", id: oswp3.id },
              { type: "work_process", id: oswp4.id },
            ]
          }
        }

        it_behaves_like "no content", :delete

        it "deletes occupation_standard_work_process records but not work process records, ignoring occupation standard work processes that are not linked" do
          expect{
            delete path, params: params, headers: header
          }.to change(OccupationStandardWorkProcess, :count).by(-2)
            .and change(WorkProcess, :count).by(0)
        end

        it "removes occupation standard work processes from association" do
          delete path, params: params, headers: header
          os.reload
          expect(os.occupation_standard_work_processes).to eq [oswp2]
        end
      end

      context "when work processes have skills" do
        let!(:oswp1) { create(:occupation_standard_work_process, occupation_standard: os) }
        let!(:oswp2) { create(:occupation_standard_work_process, occupation_standard: os) }
        let!(:oss) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp2) }
        let(:params) {
          {
            data: [
              { type: "work_process", id: oswp1.id },
              { type: "work_process", id: oswp2.id },
            ]
          }
        }

        it "does not delete occupation standard work processes" do
          expect{
            delete path, params: params, headers: header
          }.to change(OccupationStandardWorkProcess, :count).by(0)
            .and change(WorkProcess, :count).by(0)
        end

        it "returns 422 http status" do
          delete path, params: params, headers: header
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json["errors"][0]["status"]).to eq "422"
          expect(json["errors"][0]["detail"]).to match "may not be deleted"
          expect(json["errors"][0]["source"]["pointer"]).to eq "/data/1"
        end
      end
    end
  end
end
