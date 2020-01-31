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
      expect(json["meta"]["total_pages"]).to eq 1
      expect(json["meta"]["current_page"]).to eq 1
      expect(json["links"]["self"]).to eq api_v1_occupation_standards_url
      expect(json["links"]).to_not have_key("prev")
      expect(json["links"]).to_not have_key("next")
      expect(json["links"]).to_not have_key("first")
      expect(json["links"]).to_not have_key("last")
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
      user_included_hash = json["included"].detect{|hash| hash["type"] == "user"}
      expect(user_included_hash["attributes"]).to be nil

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

      # With pagination
      # Page 1
      get path, params: { page: { number: 1, size: 2 } }
      expect(response).to have_http_status(:success)
      expect(json["meta"]["total_pages"]).to eq 2
      expect(json["meta"]["current_page"]).to eq 1
      expect(json["links"]["self"]).to eq api_v1_occupation_standards_url(page: { number: 1, size: 2 })
      expect(json["links"]["first"]).to eq api_v1_occupation_standards_url(page: { number: 1, size: 2 })
      expect(json["links"]["next"]).to eq api_v1_occupation_standards_url(page: { number: 2, size: 2 })
      expect(json["links"]["last"]).to eq api_v1_occupation_standards_url(page: { number: 2, size: 2 })
      expect(json["data"].count).to eq 2
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
      expect(json["included"]).to_not be nil

      # Page 2
      get path, params: { page: { number: 2, size: 2 } }
      expect(json["meta"]["total_pages"]).to eq 2
      expect(json["meta"]["current_page"]).to eq 2
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq api_v1_occupation_standards_url(page: { number: 2, size: 2 })
      expect(json["links"]["first"]).to eq api_v1_occupation_standards_url(page: { number:  1, size: 2 })
      expect(json["links"]["prev"]).to eq api_v1_occupation_standards_url(page: { number: 1, size: 2 })
      expect(json["links"]["last"]).to eq api_v1_occupation_standards_url(page: { number: 2, size: 2 })
      expect(json["data"].count).to eq 1
      expect(json["data"][0]["id"]).to eq os1.id.to_s
      expect(json["data"][0]["type"]).to eq "occupation_standard"
      expect(json["data"][0]["attributes"]["title"]).to eq os1.title
      expect(json["data"][0]["attributes"]["organization_title"]).to eq os1.organization.title
      expect(json["data"][0]["attributes"]["occupation_title"]).to eq occupation.title
      expect(json["data"][0]["attributes"]["industry_title"]).to be nil
      expect(json["data"][0]["links"]["self"]).to eq api_v1_occupation_standard_url(os1)

      # With occupation_id and pagination
      # Page 1
      get path, params: { occupation_id: occupation.id, page: { number: 1, size: 2 } }
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq api_v1_occupation_standards_url(occupation_id: occupation.id, page: { number: 1, size: 2 })
      expect(json["links"]["first"]).to eq api_v1_occupation_standards_url(occupation_id: occupation.id, page: { number: 1, size: 2 })
      expect(json["links"]["last"]).to eq api_v1_occupation_standards_url(occupation_id: occupation.id, page: { number: 1, size: 2 })
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

      # Page 2
      get path, params: { occupation_id: occupation.id, page: { number: 2, size: 2 } }
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq api_v1_occupation_standards_url(occupation_id: occupation.id, page: { number: 2, size: 2 })
      expect(json["links"]["first"]).to eq api_v1_occupation_standards_url(occupation_id: occupation.id, page: { number: 1, size: 2 })
      expect(json["links"]["last"]).to eq api_v1_occupation_standards_url(occupation_id: occupation.id, page: { number: 1, size: 2 })
      expect(json["data"]).to be_empty
      expect(json["included"]).to be_empty

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

    let(:industry) { create(:industry) }
    let(:state) { create(:state) }
    let(:os) { create(:occupation_standard, :with_attachments, industry: industry, registration_state: state) }
    let!(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }
    let!(:oss1) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp) }
    let!(:oss2) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp) }
    let!(:oss3) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: nil) }

    it "returns the correct data" do
      get path
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq api_v1_occupation_standard_url(os)
      expect(json["data"]["id"]).to eq os.id.to_s
      expect(json["data"]["type"]).to eq "occupation_standard"
      expect(json["data"]["attributes"]["title"]).to eq os.title
      expect(json["data"]["attributes"]["organization_title"]).to eq os.organization.title
      expect(json["data"]["attributes"]["occupation_title"]).to eq os.occupation.title
      expect(json["data"]["attributes"]["industry_title"]).to eq industry.title
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
      expect(json["data"]["relationships"]["skills"]["data"][0]["id"]).to eq oss3.id.to_s

      expect(json["data"]["relationships"]["creator"]["links"]["self"]).to eq relationships_creator_api_v1_occupation_standard_url(os)
      expect(json["data"]["relationships"]["creator"]["links"]["related"]).to eq api_v1_user_url(os.creator)
      expect(json["data"]["relationships"]["creator"]["data"]["type"]).to eq "user"
      expect(json["data"]["relationships"]["creator"]["data"]["id"]).to eq os.creator_id.to_s

      expect(json["data"]["relationships"]["occupation"]["links"]["self"]).to eq relationships_occupation_api_v1_occupation_standard_url(os)
      expect(json["data"]["relationships"]["occupation"]["links"]["related"]).to eq api_v1_occupation_url(os.occupation)
      expect(json["data"]["relationships"]["occupation"]["data"]["type"]).to eq "occupation"
      expect(json["data"]["relationships"]["occupation"]["data"]["id"]).to eq os.occupation_id.to_s

      expect(json["data"]["relationships"]["organization"]["links"]["self"]).to eq relationships_organization_api_v1_occupation_standard_url(os)
      expect(json["data"]["relationships"]["organization"]["links"]["related"]).to eq api_v1_organization_url(os.organization)
      expect(json["data"]["relationships"]["organization"]["data"]["type"]).to eq "organization"
      expect(json["data"]["relationships"]["organization"]["data"]["id"]).to eq os.organization_id.to_s

      expect(json["data"]["relationships"]["industry"]["links"]["self"]).to eq relationships_industry_api_v1_occupation_standard_url(os)
      expect(json["data"]["relationships"]["industry"]["links"]["related"]).to eq api_v1_industry_url(os.industry)
      expect(json["data"]["relationships"]["industry"]["data"]["type"]).to eq "industry"
      expect(json["data"]["relationships"]["industry"]["data"]["id"]).to eq os.industry_id.to_s

      expect(json["data"]["relationships"]["registration_state"]["links"]["self"]).to eq relationships_registration_state_api_v1_occupation_standard_url(os)
      expect(json["data"]["relationships"]["registration_state"]["links"]["related"]).to eq api_v1_state_url(os.registration_state)
      expect(json["data"]["relationships"]["registration_state"]["data"]["type"]).to eq "state"
      expect(json["data"]["relationships"]["registration_state"]["data"]["id"]).to eq os.registration_state_id.to_s

      expect(json["included"]).to include(a_hash_including("type" => "work_process", "id" => oswp.id.to_s))
      expect(json["included"]).to include(a_hash_including("type" => "skill", "id" => oss3.id.to_s))
      expect(json["included"]).to include(a_hash_including("type" => "skill", "id" => oss1.id.to_s))
      expect(json["included"]).to include(a_hash_including("type" => "skill", "id" => oss2.id.to_s))
      expect(json["included"]).to include(a_hash_including("type" => "occupation", "id" => os.occupation_id.to_s))
      expect(json["included"]).to include(a_hash_including("type" => "organization", "id" => os.organization_id.to_s))
      expect(json["included"]).to include(a_hash_including("type" => "industry", "id" => industry.id.to_s))
      expect(json["included"]).to include(a_hash_including("type" => "state", "id" => state.id.to_s))
      expect(json["included"]).to include(a_hash_including("type" => "user", "id" => os.creator_id.to_s))
      user_included_hash = json["included"].detect{|hash| hash["type"] == "user"}
      expect(user_included_hash["attributes"]).to be nil
    end
  end

  describe "POST #create" do
    let(:path) { "/api/v1/occupation_standards" }
    let(:employer) { create(:organization) }
    let(:user) { create(:user, employer: employer) }
    let(:header) { auth_header(user) }

    context "with valid params" do
      let(:os) { create(:occupation_standard) }

      context "when passing title" do
        let(:params) {
          {
            data: {
              type: "occupation_standard",
              attributes: {
                parent_occupation_standard_id: os.id,
                title: "copy of standard",
              },
            }
          }
        }

        it_behaves_like "authorization", :post

        it "returns new occupation standard" do
          post path, params: params, headers: header
          new_os = OccupationStandard.last
          expect(response).to have_http_status(:success)
          expect(json["data"]["id"]).to eq new_os.id.to_s
          expect(json["data"]["type"]).to eq "occupation_standard"
          expect(json["data"]["attributes"]["title"]).to eq "copy of standard"
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

          expect(json["data"]["relationships"]["organization"]["links"]["self"]).to eq relationships_organization_api_v1_occupation_standard_url(new_os)
          expect(json["data"]["relationships"]["organization"]["links"]["related"]).to eq api_v1_organization_url(new_os.organization)
          expect(json["data"]["relationships"]["organization"]["data"]["type"]).to eq "organization"
          expect(json["data"]["relationships"]["organization"]["data"]["id"]).to eq new_os.organization_id.to_s

          expect(json["included"]).to_not be_empty
        end
      end

      context "when not passing title" do
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

        it "returns new occupation standard" do
          post path, params: params, headers: header
          new_os = OccupationStandard.last
          expect(response).to have_http_status(:success)
          expect(json["data"]["id"]).to eq new_os.id.to_s
          expect(json["data"]["type"]).to eq "occupation_standard"
          expect(json["data"]["attributes"]["title"]).to eq "#{os.title} COPY"
        end
      end
    end

    context "with invalid parent occupation standard" do
      context "with bad standard id" do
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

      context "when user is missing employer" do
        let(:user) { create(:user, employer: nil) }
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

        it "returns 422 http status" do
          post path, params: params, headers: header
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json["errors"][0]["status"]).to eq "422"
          expect(json["errors"][0]["detail"]).to match "Organization must exist"
        end
      end

      context "when missing attributes data" do
        let(:params) {
          {
            data: {
              type: "occupation_standard",
                attributes: {
              }
            }
          }
        }

        it "returns 422 http status" do
          post path, params: params, headers: header
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json["errors"][0]["status"]).to eq "422"
          expect(json["errors"][0]["detail"]).to match "empty: attributes"
        end
      end
    end
  end

  describe "DELETE #destroy" do
    let(:path) { "/api/v1/occupation_standards/#{os.id}" }
    let!(:os) { create(:occupation_standard, creator: user) }
    let(:user) { create(:user) }
    let(:params) { {} }
    let(:header) { auth_header(user) }

    it_behaves_like "authorization", :delete

    context "when user owns occupation standard" do
      let!(:relationship) { create(:relationship, occupation_standard: os) }
      let!(:oss) { create(:occupation_standard_skill, occupation_standard: os) }
      let!(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }
      let!(:standards_registration) { create(:standards_registration, occupation_standard: os) }

      it "deletes standard, skill, work_process, and relationship records" do
        expect{
          delete path, headers: header
        }.to change(user.occupation_standards, :count).by(-1)
          .and change(Relationship, :count).by(-1)
          .and change(OccupationStandardSkill, :count).by(-1)
          .and change(OccupationStandardWorkProcess, :count).by(-1)
          .and change(StandardsRegistration, :count).by(-1)
      end
    end

    context "when user does not own occupation standard" do
      let!(:os) { create(:occupation_standard) }
      let!(:relationship) { create(:relationship, occupation_standard: os) }

      it_behaves_like "unauthorized", :delete

      it "does not change occupation standard count or relationship count" do
        expect{
          delete path, headers: header
        }.to change(user.occupation_standards, :count).by(0)
          .and change(Relationship, :count).by(0)
      end
    end
  end

  describe "PATCH #update" do
    let(:path) { "/api/v1/occupation_standards/#{os.id}" }
    let(:user) { create(:user) }
    let(:os) { create(:occupation_standard) }
    let(:header) { auth_header(user) }

    context "when user owns occupation standard" do
      let(:os) { create(:occupation_standard, creator: user) }

      context "with valid params" do
        context "when updating relationships" do
          let(:state) { create(:state) }
          let(:occupation) { create(:occupation) }
          let(:industry) { create(:industry) }
          let(:params) {
            {
              data: {
                id: os.id.to_s,
                type: "occupation_standard",
                attributes: {
                  title: "new title",
                  registration_organization_name: "new reg org name",
                  organization_title: "new org name",
                },
                relationships: {
                  occupation: {
                    data: { type: "occupation", id: occupation.id.to_s }
                  },
                  industry: {
                    data: { type: "industry", id: industry.id.to_s }
                  },
                  registration_state: {
                    data: { type: "state", id: state.id.to_s }
                  },
                },
              }
            }
          }

          it_behaves_like "authorization", :patch

          it "returns updated occupation standard" do
            patch path, params: params, headers: header
            expect(response).to have_http_status(:success)
            expect(json["data"]["id"]).to eq os.id.to_s
            expect(json["data"]["type"]).to eq "occupation_standard"
            expect(json["data"]["attributes"]["title"]).to eq "new title"
            expect(json["data"]["attributes"]["organization_title"]).to eq "new org name"
            expect(json["data"]["attributes"]["occupation_title"]).to eq occupation.title
            expect(json["data"]["attributes"]["industry_title"]).to eq industry.title
            expect(json["data"]["attributes"]["should_generate_attachments"]).to be true
            expect(json["data"]["attributes"]["pdf_filename"]).to be nil
            expect(json["data"]["attributes"]["pdf_url"]).to be nil
            expect(json["data"]["attributes"]["pdf_created_at"]).to be nil
            expect(json["data"]["attributes"]["excel_filename"]).to be nil
            expect(json["data"]["attributes"]["excel_url"]).to be nil
            expect(json["data"]["attributes"]["excel_created_at"]).to be nil
            expect(json["data"]["attributes"]["registration_organization_name"]).to eq "new reg org name"
            expect(json["data"]["attributes"]["registration_state_name"]).to eq state.short_name

            expect(json["data"]["relationships"]["occupation"]["links"]["self"]).to eq relationships_occupation_api_v1_occupation_standard_url(os)
            expect(json["data"]["relationships"]["occupation"]["links"]["related"]).to eq api_v1_occupation_url(occupation)
            expect(json["data"]["relationships"]["occupation"]["data"]["type"]).to eq "occupation"
            expect(json["data"]["relationships"]["occupation"]["data"]["id"]).to eq occupation.id.to_s

            expect(json["data"]["relationships"]["organization"]["links"]["self"]).to eq relationships_organization_api_v1_occupation_standard_url(os)
            expect(json["data"]["relationships"]["organization"]["links"]["related"]).to eq api_v1_organization_url(Organization.last)
            expect(json["data"]["relationships"]["organization"]["data"]["type"]).to eq "organization"
            expect(json["data"]["relationships"]["organization"]["data"]["id"]).to eq Organization.last.id.to_s

            expect(json["included"]).to_not be_empty
          end
        end

        context "when not updating relationships" do
          let(:params) {
            {
              data: {
                id: os.id.to_s,
                type: "occupation_standard",
                attributes: {
                  title: "new title",
                  registration_organization_name: "new reg org name",
                  organization_title: "new org name",
                },
              }
            }
          }

          it "returns updated occupation standard" do
            patch path, params: params, headers: header
            expect(response).to have_http_status(:success)
            expect(json["data"]["id"]).to eq os.id.to_s
            expect(json["data"]["type"]).to eq "occupation_standard"
            expect(json["data"]["attributes"]["title"]).to eq "new title"
            expect(json["data"]["attributes"]["organization_title"]).to eq "new org name"
            expect(json["data"]["attributes"]["industry_title"]).to be nil
            expect(json["data"]["attributes"]["registration_organization_name"]).to eq "new reg org name"
            expect(json["data"]["attributes"]["registration_state_name"]).to be nil
          end
        end
      end

      context "with invalid parameters" do
        context "with missing title" do
          let(:params) {
            {
              data: {
                id: os.id.to_s,
                type: "occupation_standard",
                attributes: {
                  title: "",
                  registration_organization_name: "new reg org name",
                },
              }
            }
          }

          it "does not update occupation standard" do
            patch path, params: params, headers: header
            os.reload
            expect(os.registration_organization_name).to_not eq "new reg org name"
          end

          it "returns 422 http status" do
            patch path, params: params, headers: header
            expect(response).to have_http_status(:unprocessable_entity)
            expect(json["errors"][0]["status"]).to eq "422"
            expect(json["errors"][0]["detail"]).to match "can't be blank"
          end
        end
      end

      context "when missing data values" do
        let(:params) {
          {
            data: {
            }
          }
        }

        it "returns 422 http status" do
          patch path, params: params, headers: header
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json["errors"][0]["status"]).to eq "422"
          expect(json["errors"][0]["detail"]).to match "empty: data"
        end
      end
    end

    context "with user who does not own occupation standard" do
      it_behaves_like "unauthorized", :patch do
        let(:params) {
          {
            data: {
              id: os.id.to_s,
              type: "occupation_standard",
              attributes: {
                title: "new title",
              },
            }
          }
        }
      end
    end
  end
end
