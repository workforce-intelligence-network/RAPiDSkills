require 'rails_helper'

RSpec.describe API::V1::OccupationStandardWorkProcesses::Relationships::CategoriesController, type: :request do
  describe "GET #index" do
    let(:path) { "/api/v1/work_processes/#{oswp.id}/relationships/categories" }
    let(:oswp) { create(:occupation_standard_work_process) }
    let!(:cat1) { create(:category, occupation_standard_work_process: oswp, sort_order: 2) }
    let!(:cat2) { create(:category, occupation_standard_work_process: oswp, sort_order: 1) }

    it "returns the correct data" do
      get path
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq relationships_categories_api_v1_occupation_standard_work_process_url(oswp)
      expect(json["links"]["related"]).to eq api_v1_occupation_standard_work_process_categories_url(oswp)
      expect(json["data"].count).to eq 2
      expect(json["data"][0]["type"]).to eq "category"
      expect(json["data"][0]["id"]).to eq cat2.id.to_s
      expect(json["data"][1]["type"]).to eq "category"
      expect(json["data"][1]["id"]).to eq cat1.id.to_s
    end
  end

  describe "DELETE #destroy" do
    let(:path) { "/api/v1/work_processes/#{oswp.id}/relationships/categories" }
    let(:oswp) { create(:occupation_standard_work_process) }
    let(:header) { {} }
    let(:params) { {} }

    context "when guest" do
      it_behaves_like "unauthorized", :delete
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

      context "when category has no skills" do
        let!(:cat1) { create(:category, occupation_standard_work_process: oswp) }
        let!(:cat2) { create(:category, occupation_standard_work_process: oswp) }
        let!(:cat3) { create(:category, occupation_standard_work_process: oswp) }
        let!(:cat4) { create(:category) }
        let(:params) {
          {
            data: [
              { type: "category", id: cat1.id },
              { type: "category", id: cat3.id },
              { type: "category", id: cat4.id },
            ]
          }
        }

        it_behaves_like "no content", :delete

        it "deletes category records, ignoring categories that are not linked" do
          expect{
            delete path, params: params, headers: header
          }.to change(Category, :count).by(-2)
        end

        it "removes categories from association" do
          delete path, params: params, headers: header
          oswp.reload
          expect(oswp.categories).to eq [cat2]
        end
      end

      context "when categories have skills" do
        let!(:cat1) { create(:category, occupation_standard_work_process: oswp) }
        let!(:cat2) { create(:category, occupation_standard_work_process: oswp) }
        let!(:oss) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp, category: cat2) }
        let(:params) {
          {
            data: [
              { type: "category", id: cat1.id },
              { type: "category", id: cat2.id },
            ]
          }
        }

        it "does not delete categories" do
          expect{
            delete path, params: params, headers: header
          }.to_not change(Category, :count)
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
