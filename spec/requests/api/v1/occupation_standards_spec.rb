require 'rails_helper'

RSpec.describe API::V1::OccupationStandardsController, type: :request do
  describe "GET #index" do
    let(:occupation) { create(:occupation) }
    let!(:os1) { create(:occupation_standard, occupation: occupation) }
    let!(:os2) { create(:occupation_standard) }
    let!(:os3) { create(:occupation_standard, occupation: occupation) }
    let(:path) { "/api/v1/occupation_standards" }

    it "returns the correct data" do
      # With no occupation_id parameter, returns all data
      get path
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq api_v1_occupation_standards_url
      expect(json["data"].count).to eq 3
      expect(json["data"][0]["id"]).to eq os3.id.to_s
      expect(json["data"][0]["type"]).to eq "occupation_standard"
      expect(json["data"][0]["attributes"]["title"]).to eq os3.title
      expect(json["data"][0]["attributes"]["organization_title"]).to eq os3.organization.title
      expect(json["data"][0]["attributes"]["occupation_title"]).to eq occupation.title
      expect(json["data"][0]["attributes"]["industry_title"]).to be nil
      expect(json["data"][0]["links"]["self"]).to eq api_v1_occupation_standard_url(os3)

      expect(json["data"][1]["id"]).to eq os2.id.to_s
      expect(json["data"][1]["type"]).to eq "occupation_standard"
      expect(json["data"][1]["attributes"]["title"]).to eq os2.title
      expect(json["data"][1]["attributes"]["organization_title"]).to eq os2.organization.title
      expect(json["data"][1]["attributes"]["occupation_title"]).to eq os2.occupation.title
      expect(json["data"][1]["attributes"]["industry_title"]).to be nil
      expect(json["data"][1]["links"]["self"]).to eq api_v1_occupation_standard_url(os2)

      expect(json["data"][2]["id"]).to eq os1.id.to_s
      expect(json["data"][2]["type"]).to eq "occupation_standard"
      expect(json["data"][2]["attributes"]["title"]).to eq os1.title
      expect(json["data"][2]["attributes"]["organization_title"]).to eq os1.organization.title
      expect(json["data"][2]["attributes"]["occupation_title"]).to eq occupation.title
      expect(json["data"][2]["attributes"]["industry_title"]).to be nil
      expect(json["data"][2]["links"]["self"]).to eq api_v1_occupation_standard_url(os1)
      expect(json["included"]).to_not be nil

      # With occupation_id parameter, returns matches
      get path, params: { occupation_id: occupation.id }
      expect(response).to have_http_status(:success)
      expect(json["data"].count).to eq 2
      expect(json["data"][0]["id"]).to eq os3.id.to_s
      expect(json["data"][0]["type"]).to eq "occupation_standard"
      expect(json["data"][0]["attributes"]["title"]).to eq os3.title
      expect(json["data"][0]["attributes"]["organization_title"]).to eq os3.organization.title
      expect(json["data"][0]["attributes"]["occupation_title"]).to eq occupation.title
      expect(json["data"][0]["attributes"]["industry_title"]).to be nil
      expect(json["data"][0]["links"]["self"]).to eq api_v1_occupation_standard_url(os3)

      expect(json["data"][1]["id"]).to eq os1.id.to_s
      expect(json["data"][1]["type"]).to eq "occupation_standard"
      expect(json["data"][1]["attributes"]["title"]).to eq os1.title
      expect(json["data"][1]["attributes"]["organization_title"]).to eq os1.organization.title
      expect(json["data"][1]["attributes"]["occupation_title"]).to eq occupation.title
      expect(json["data"][1]["attributes"]["industry_title"]).to be nil
      expect(json["data"][1]["links"]["self"]).to eq api_v1_occupation_standard_url(os1)
      expect(json["included"]).to_not be nil

      # With bad occupation_id parameter, returns none
      get path, params: { occupation_id: 9999 }
      expect(response).to have_http_status(:success)
      expect(json["data"]).to be_empty
      expect(json["included"]).to be_empty
    end
  end

  describe "GET #show" do
    let(:path) { "/api/v1/occupation_standards/#{os.id}" }

    before { Timecop.freeze(Time.new(2019,8,13,12,13,14)) }
    after { Timecop.return }

    let(:os) { create(:occupation_standard, :with_attachments) }
    let!(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }
    let!(:oss1) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp) }
    let!(:oss2) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: nil) }

    it "returns the correct data" do
      get path
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq api_v1_occupation_standard_url(os)
      expect(json["data"]["id"]).to eq os.id.to_s
      expect(json["data"]["type"]).to eq "occupation_standard"
      expect(json["data"]["attributes"]["title"]).to eq os.title
      expect(json["data"]["attributes"]["organization_title"]).to eq os.organization.title
      expect(json["data"]["attributes"]["occupation_title"]).to eq os.occupation.title
      expect(json["data"]["attributes"]["industry_title"]).to be nil
      expect(json["data"]["attributes"]["should_generate_attachments"]).to be false
      expect(json["data"]["attributes"]["pdf_filename"]).to eq "pixel1x1.pdf"
      expect(json["data"]["attributes"]["pdf_url"]).to_not be nil
      expect(json["data"]["attributes"]["pdf_created_at"]).to eq "2019-08-13T12:13:14.000Z"
      expect(json["data"]["attributes"]["excel_filename"]).to eq "test.csv"
      expect(json["data"]["attributes"]["excel_url"]).to_not be nil
      expect(json["data"]["attributes"]["excel_created_at"]).to eq "2019-08-13T12:13:14.000Z"

      expect(json["data"]["relationships"]["work_processes"]["links"]["self"]).to eq relationships_work_processes_api_v1_occupation_standard_url(os)
      expect(json["data"]["relationships"]["work_processes"]["links"]["related"]).to eq api_v1_occupation_standard_occupation_standard_work_processes_url(os)
      expect(json["data"]["relationships"]["work_processes"]["data"].count).to eq 1
      expect(json["data"]["relationships"]["work_processes"]["data"][0]["type"]).to eq "work_process"
      expect(json["data"]["relationships"]["work_processes"]["data"][0]["id"]).to eq oswp.id.to_s

      expect(json["data"]["relationships"]["skills"]["links"]["self"]).to eq relationships_skills_api_v1_occupation_standard_url(os)
      expect(json["data"]["relationships"]["skills"]["links"]["related"]).to eq api_v1_occupation_standard_occupation_standard_skills_url(os)
      expect(json["data"]["relationships"]["skills"]["data"].count).to eq 1
      expect(json["data"]["relationships"]["skills"]["data"][0]["type"]).to eq "skill"
      expect(json["data"]["relationships"]["skills"]["data"][0]["id"]).to eq oss2.id.to_s

      expect(json["data"]["relationships"]["occupation"]["links"]["self"]).to eq relationships_occupation_api_v1_occupation_standard_url(os)
      expect(json["data"]["relationships"]["occupation"]["links"]["related"]).to eq api_v1_occupation_url(os.occupation)
      expect(json["data"]["relationships"]["occupation"]["data"]["type"]).to eq "occupation"
      expect(json["data"]["relationships"]["occupation"]["data"]["id"]).to eq os.occupation_id.to_s

      included_array = [
        {
          type: "work_process",
          id: oswp.id.to_s,
          attributes: {
            title: oswp.work_process.title,
            description: oswp.work_process.description,
          }.stringify_keys,
          relationships: {
            skills: {
              links: {
                self: relationships_skills_api_v1_occupation_standard_work_process_url(oswp),
                related: api_v1_occupation_standard_work_process_occupation_standard_skills_url(oswp),
              }.stringify_keys,
              data: [ { type: "skill", id: oss1.id.to_s }.stringify_keys ],
            }.stringify_keys,
          }.stringify_keys,
        }.stringify_keys,
        {
          type: "skill",
          id: oss2.id.to_s,
          attributes: {
            description: oss2.skill.description,
          }.stringify_keys,
          links: {
            self: api_v1_occupation_standard_skill_url(oss2),
          }.stringify_keys,
        }.stringify_keys,
        {
          type: "skill",
          id: oss1.id.to_s,
          attributes: {
            description: oss1.skill.description,
          }.stringify_keys,
          links: {
            self: api_v1_occupation_standard_skill_url(oss1),
          }.stringify_keys,
        }.stringify_keys,
        {
          type: "occupation",
          id: os.occupation_id.to_s,
          attributes: {
            title: os.occupation.title,
            kind: "hybrid",
            rapids_code: os.occupation.rapids_code,
            onet_code: os.occupation.onet_code,
            onet_page_url: os.occupation.onet_page_url,
            term_length_min: os.occupation.term_length_min,
            term_length_max: os.occupation.term_length_max,
            title_aliases: "",
          }.stringify_keys,
          links: {
            self: api_v1_occupation_url(os.occupation),
          }.stringify_keys,
        }.stringify_keys,
      ]
      expect(json["included"]).to match_array included_array
    end
  end

  describe "POST #create" do
    let(:path) { "/api/v1/occupation_standards" }
    let(:employer) { create(:organization) }
    let(:user) { create(:user, employer: employer) }
    let(:header) { auth_header(user) }

    context "with valid params" do
      let(:os) { create(:occupation_standard) }
      let(:params) {
        {
          data: {
            type: "occupation_standard",
            attributes: {
              parent_occupation_standard_id: os.id,
            },
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
        expect(json["data"]["relationships"]["work_processes"]["links"]["related"]).to eq api_v1_occupation_standard_occupation_standard_work_processes_url(new_os)
        expect(json["data"]["relationships"]["work_processes"]["data"]).to be_empty

        expect(json["data"]["relationships"]["skills"]["links"]["self"]).to eq relationships_skills_api_v1_occupation_standard_url(new_os)
        expect(json["data"]["relationships"]["skills"]["links"]["related"]).to eq api_v1_occupation_standard_occupation_standard_skills_url(new_os)
        expect(json["data"]["relationships"]["skills"]["data"]).to be_empty

        expect(json["data"]["relationships"]["occupation"]["links"]["self"]).to eq relationships_occupation_api_v1_occupation_standard_url(new_os)
        expect(json["data"]["relationships"]["occupation"]["links"]["related"]).to eq api_v1_occupation_url(new_os.occupation)
        expect(json["data"]["relationships"]["occupation"]["data"]["type"]).to eq "occupation"
        expect(json["data"]["relationships"]["occupation"]["data"]["id"]).to eq new_os.occupation_id.to_s

        expect(json["included"]).to_not be_empty
      end
    end

    context "with invalid parent occupation standard" do
      let(:params) {
        {
          data: {
            type: "occupation_standard",
            attributes: {
              parent_occupation_standard_id: 999,
            },
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
        expect(json["errors"][0]["detail"]).to match "is invalid"
      end
    end
  end
end
