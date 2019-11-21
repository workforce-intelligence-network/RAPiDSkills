require 'rails_helper'

RSpec.describe API::V1::ClonesController, type: :request do
  describe "POST #create" do
    let(:path) { "/api/v1/clones" }
    let(:employer) { create(:organization) }
    let(:user) { create(:user, employer: employer) }
    let(:header) { auth_header(user) }

    context "with valid params" do
      let(:os) { create(:occupation_standard) }
      let(:params) {
        {
          data: {
            type: "clone",
            relationships: {
              clonable: {
                data: {
                  type: "occupation_standard",
                  id: os.id.to_s,
                }
              }
            }
          }
        }
      }
      let(:new_os) { create(:occupation_standard, parent_occupation_standard: os) }

      it_behaves_like "authorization", :post

      it "returns new occupation standard" do
        expect_any_instance_of(OccupationStandard).to receive(:clone_as_unregistered!).with(creator_id: user.id, organization_id: employer.id).and_return(new_os)
        post path, params: params, headers: header
        expect(response).to have_http_status(:success)
        expect(json["data"]["id"]).to eq new_os.id.to_s
        expect(json["data"]["type"]).to eq "occupation_standard"
        expect(json["data"]["attributes"]["title"]).to eq new_os.title
        expect(json["data"]["attributes"]["organization_title"]).to eq new_os.organization.title
        expect(json["data"]["attributes"]["occupation_title"]).to eq new_os.occupation.title
        expect(json["data"]["attributes"]["industry_title"]).to be nil
        expect(json["data"]["attributes"]["should_generate_attachments"]).to be true
        expect(json["data"]["attributes"]["pdf_filename"]).to be nil
        expect(json["data"]["attributes"]["pdf_url"]).to be nil
        expect(json["data"]["attributes"]["pdf_created_at"]).to be nil
        expect(json["data"]["attributes"]["excel_filename"]).to be nil
        expect(json["data"]["attributes"]["excel_url"]).to be nil
        expect(json["data"]["attributes"]["excel_created_at"]).to be nil

        expect(json["data"]["relationships"]["work_processes"]["links"]["self"]).to eq relationships_work_processes_api_v1_occupation_standard_url(new_os)
        expect(json["data"]["relationships"]["work_processes"]["links"]["related"]).to eq api_v1_occupation_standard_work_processes_url(new_os)
        expect(json["data"]["relationships"]["work_processes"]["data"]).to be_empty

        expect(json["data"]["relationships"]["skills"]["links"]["self"]).to eq relationships_skills_api_v1_occupation_standard_url(new_os)
        expect(json["data"]["relationships"]["skills"]["links"]["related"]).to eq api_v1_occupation_standard_skills_url(new_os)
        expect(json["data"]["relationships"]["skills"]["data"]).to be_empty
        expect(json["included"]).to be_empty
      end
    end

    context "with invalid params" do
      context "when missing relationship data" do
        let(:params) {
          {
            data: {
              type: "clone"
            }
          }
        }

        it "does not call clone method" do
          expect_any_instance_of(OccupationStandard).to_not receive(:clone_as_unregistered!)
          post path, params: params, headers: header
        end

        it "returns 422 http status" do
          post path, params: params, headers: header
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json["errors"][0]["status"]).to eq "422"
          expect(json["errors"][0]["detail"]).to match "empty: relationships"
        end
      end

      context "when bad type" do
        let(:work_process) { create(:work_process) }
        let(:params) {
          {
            data: {
              type: "clone",
              relationships: {
                clonable: {
                  data: {
                    type: "work_process",
                    id: work_process.id.to_s
                  }
                }
              }
            }
          }
        }

        it "returns 406 http status" do
          post path, params: params, headers: header
          expect(response).to have_http_status(:not_acceptable)
          expect(json["errors"][0]["status"]).to eq "406"
          expect(json["errors"][0]["title"]).to eq "Records of type work_process are not clonable"
          expect(json["errors"][0]["detail"]).to eq "Valid clonable record types include: occupation_standard"
          expect(json["errors"][0]["source"]["pointer"]).to eq "/data/relationships/clonable/data/type"
        end
      end

      context "when bad occupation standard id" do
        let(:params) {
          {
            data: {
              type: "clone",
              relationships: {
                clonable: {
                  data: {
                    type: "occupation_standard",
                    id: "999"
                  }
                }
              }
            }
          }
        }

        it "does not call clone method" do
          expect_any_instance_of(OccupationStandard).to_not receive(:clone_as_unregistered!)
          post path, params: params, headers: header
        end

        it "returns not found http status" do
          post path, params: params, headers: header
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
