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
      let!(:oswp1) { create(:occupation_standard_work_process, occupation_standard: os) }
      let!(:oswp2) { create(:occupation_standard_work_process, occupation_standard: os) }
      let!(:oswp3) { create(:occupation_standard_work_process, occupation_standard: os) }
      let(:params) {
        {
          data: [
            { type: "work_process", id: oswp1.id },
            { type: "work_process", id: oswp3.id },
          ]
        }
      }

      it_behaves_like "no content", :delete

      it "deletes occupation standard work process records but not work process records" do
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
  end
end
