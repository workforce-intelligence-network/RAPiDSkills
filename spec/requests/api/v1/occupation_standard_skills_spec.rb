require 'rails_helper'

RSpec.describe API::V1::OccupationStandardSkillsController, type: :request do
  describe "GET #index" do
    let(:path) { "/api/v1/occupation_standards/#{os.id}/skills" }

    let(:os) { create(:occupation_standard) }
    let!(:oss1) { create(:occupation_standard_skill, occupation_standard: os, sort_order: 2, occupation_standard_work_process: nil) }
    let!(:oss2) { create(:occupation_standard_skill, occupation_standard: os, sort_order: 1, occupation_standard_work_process: nil) }
    let!(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }
    let!(:oss3) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp) }

    context "with valid standard" do
      it "returns the correct data" do
        get path
        expect(response).to have_http_status(:success)
        expect(json["links"]["self"]).to eq api_v1_occupation_standard_occupation_standard_skills_url(os)
        expect(json["data"].count).to eq 2
        expect(json["data"][0]["id"]).to eq oss2.id.to_s
        expect(json["data"][0]["type"]).to eq "skill"
        expect(json["data"][0]["attributes"]["description"]).to eq oss2.skill.description
        expect(json["data"][1]["id"]).to eq oss1.id.to_s
        expect(json["data"][1]["type"]).to eq "skill"
        expect(json["data"][1]["attributes"]["description"]).to eq oss1.skill.description
      end
    end

    context "with bad standard id" do
      it_behaves_like "not found", :get do
        let(:path) { "/api/v1/occupation_standards/999/skills" }
        let(:params) { {} }
        let(:header) { {} }
      end
    end
  end

  describe "GET #show" do
    let(:path) { "/api/v1/skills/#{oss.id}" }
    let(:oss) { create(:occupation_standard_skill) }

    context "with valid skill id" do
      it "returns the correct data" do
        get path
        expect(response).to have_http_status(:success)
        expect(json["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
        expect(json["data"]["id"]).to eq oss.id.to_s
        expect(json["data"]["type"]).to eq "skill"
        expect(json["data"]["attributes"]["description"]).to eq oss.skill.description
        expect(json["data"]["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
      end
    end

    context "with bad skill id" do
      it_behaves_like "not found", :get do
        let(:path) { "/api/v1/skills/999" }
        let(:params) { {} }
        let(:header) { {} }
      end
    end
  end

  describe "PATCH #update" do
    let(:path) { "/api/v1/skills/#{oss.id}" }
    let(:user) { create(:user) }
    let(:os) { create(:occupation_standard) }
    let!(:oss) { create(:occupation_standard_skill, occupation_standard: os) }
    let(:header) { auth_header(user) }
    let(:params) {
      {
        data: {
          type: "skill",
          id: oss.id.to_s,
          attributes: {
            description: "this is an updated desc",
          }
        }
      }
    }

    context "when user belongs to occupation_standard" do
      let(:os) { create(:occupation_standard, creator: user) }

      it_behaves_like "authorization", :patch

      context "with valid parameters" do
        context "when new skill name does not exist" do
          it "creates a new skill and links skill to oss" do
            original_skill = oss.skill
            expect{
              patch path, params: params, headers: header
            }.to change(Skill, :count).by(1)
            skill = Skill.last
            expect(skill.description).to eq "this is an updated desc"
            expect(skill.parent_skill).to eq original_skill
            oss.reload
            expect(oss.skill).to eq skill
          end

          it "returns correct response" do
            patch path, params: params, headers: header
            expect(response).to have_http_status(:success)
            expect(json["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
            expect(json["data"]["id"]).to eq oss.id.to_s
            expect(json["data"]["type"]).to eq "skill"
            expect(json["data"]["attributes"]["description"]).to eq "this is an updated desc"
            expect(json["data"]["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
          end
        end

        context "when new skill name does exist" do
          let(:parent) { create(:skill) }
          let!(:skill) { create(:skill, description: "this is an updated desc", parent_skill: parent) }

          it "does not create a new skill but links skill to oss" do
            expect{
              patch path, params: params, headers: header
            }.to_not change(Skill, :count)
            oss.reload
            expect(oss.skill).to eq skill
            expect(skill.reload.parent_skill).to eq parent
          end

          it "returns correct response" do
            patch path, params: params, headers: header
            expect(response).to have_http_status(:success)
            expect(json["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
            expect(json["data"]["id"]).to eq oss.id.to_s
            expect(json["data"]["type"]).to eq "skill"
            expect(json["data"]["attributes"]["description"]).to eq "this is an updated desc"
            expect(json["data"]["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
          end
        end
      end

      context "with invalid parameters" do
        let(:params) {
          {
            data: {
              type: "skill",
              id: oss.id.to_s,
              attributes: {
                description: "",
              }
            }
          }
        }

        it "does not create new skill" do
          expect{
            patch path, params: params, headers: header
          }.to_not change(Skill, :count)
        end

        it "returns 422 with an error message" do
          patch path, params: params, headers: header
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json["errors"][0]["status"]).to eq "422"
          expect(json["errors"][0]["detail"]).to eq "Description can't be blank"
        end
      end

      context "with bad skill id" do
        it_behaves_like "not found", :patch do
          let(:path) { "/api/v1/skills/999" }
        end
      end
    end

    context "when user does not belong to occupation standard" do
      it_behaves_like "forbidden", :patch
    end
  end

  describe "POST #create" do
    let(:path) { "/api/v1/skills" }
    let(:user) { create(:user) }
    let(:header) { auth_header(user) }
    let(:params) {
      {
        data: {
          type: "skill",
          attributes: {
            description: "this is a new skill",
          },
          relationships: {
            occupation_standard: {
              data: {
                type: "occupation_standard",
                id: os.id.to_s,
              }
            }
          }
        }
      }
    }

    context "when user belongs to occupation_standard" do
      let(:os) { create(:occupation_standard, creator: user) }

      it_behaves_like "authorization", :post

      context "with valid parameters" do
        context "when not passing work process parent" do
          context "when new skill name does not exist" do
            it "creates a new skill and new occupation standard skill" do
              expect{
                post path, params: params, headers: header
              }.to change(Skill, :count).by(1)
                .and change(OccupationStandardSkill, :count).by(1)
              skill = Skill.last
              expect(skill.description).to eq "this is a new skill"
              expect(skill.parent_skill).to be nil
              oss = OccupationStandardSkill.last
              expect(oss.skill).to eq skill
              expect(oss.occupation_standard).to eq os
              expect(oss.occupation_standard_work_process).to be nil
            end

            it "returns correct response" do
              post path, params: params, headers: header
              expect(response).to have_http_status(:success)
              oss = OccupationStandardSkill.last
              expect(json["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
              expect(json["data"]["id"]).to eq oss.id.to_s
              expect(json["data"]["type"]).to eq "skill"
              expect(json["data"]["attributes"]["description"]).to eq "this is a new skill"
              expect(json["data"]["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
            end
          end

          context "when new skill name does exist" do
            let!(:skill) { create(:skill, description: "this is a new skill") }

            it "does not create a new skill but creates new oss" do
              expect{
                post path, params: params, headers: header
              }.to change(Skill, :count).by(0)
                .and change(OccupationStandardSkill, :count).by(1)
              oss = OccupationStandardSkill.last
              expect(oss.skill).to eq skill
              expect(oss.occupation_standard).to eq os
              expect(oss.occupation_standard_work_process).to be nil
            end

            it "returns correct response" do
              post path, params: params, headers: header
              oss = OccupationStandardSkill.last
              expect(response).to have_http_status(:success)
              expect(json["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
              expect(json["data"]["id"]).to eq oss.id.to_s
              expect(json["data"]["type"]).to eq "skill"
              expect(json["data"]["attributes"]["description"]).to eq "this is a new skill"
              expect(json["data"]["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
            end
          end
        end

        context "when passing work process parent" do
          let(:params) {
            {
              data: {
                type: "skill",
                attributes: {
                  description: "this is a new skill",
                },
                relationships: {
                  work_process: {
                    data: {
                      type: "work_process",
                      id: oswp.id.to_s,
                    }
                  }
                }
              }
            }
          }

          context "when work process belongs to standard" do
            let(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }

            it "creates a new skill and new occupation standard skill" do
              expect{
                post path, params: params, headers: header
              }.to change(Skill, :count).by(1)
                .and change(OccupationStandardSkill, :count).by(1)
              skill = Skill.last
              expect(skill.description).to eq "this is a new skill"
              expect(skill.parent_skill).to be nil
              oss = OccupationStandardSkill.last
              expect(oss.skill).to eq skill
              expect(oss.occupation_standard).to eq os
              expect(oss.occupation_standard_work_process).to eq oswp
            end

            it "returns correct response" do
              post path, params: params, headers: header
              expect(response).to have_http_status(:success)
              oss = OccupationStandardSkill.last
              expect(json["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
              expect(json["data"]["id"]).to eq oss.id.to_s
              expect(json["data"]["type"]).to eq "skill"
              expect(json["data"]["attributes"]["description"]).to eq "this is a new skill"
              expect(json["data"]["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
            end
          end

          context "when work process does not belong to standard" do
            let(:oswp) { create(:occupation_standard_work_process) }

            it "does not create a new skill or new occupation standard skill" do
              expect{
                post path, params: params, headers: header
              }.to change(Skill, :count).by(0)
                .and change(OccupationStandardSkill, :count).by(0)
            end

            it_behaves_like "forbidden", :post
          end
        end
      end

      context "with invalid parameters" do
        context "when description is blank" do
          let(:params) {
            {
              data: {
                type: "skill",
                attributes: {
                  description: "",
                },
                relationships: {
                  occupation_standard: {
                    data: {
                      type: "occupation_standard",
                      id: os.id.to_s,
                    }
                  }
                }
              }
            }
          }

          it "does not create new skill or oss" do
            expect{
              post path, params: params, headers: header
            }.to change(Skill, :count).by(0)
              .and change(OccupationStandardSkill, :count).by(0)
          end

          it "returns 422 with an error message" do
            post path, params: params, headers: header
            expect(response).to have_http_status(:unprocessable_entity)
            expect(json["errors"][0]["status"]).to eq "422"
            expect(json["errors"][0]["detail"]).to eq "Description can't be blank"
          end
        end

        context "with bad standard and work process ids" do
          it_behaves_like "not found", :post do
            let(:params) {
              {
                data: {
                  type: "skill",
                  attributes: {
                    description: "this is a new skill",
                  },
                  relationships: {
                    occupation_standard: {
                      data: {
                        type: "occupation_standard",
                        id: 9999,
                      }
                    },
                    work_process: {
                      data: {
                        type: "work_process",
                        id: 9999,
                      }
                    }
                  }
                }
              }
            }
          end
        end

        context "when missing relationships key" do
          let(:params) {
            {
              data: {
                type: "skill",
                attributes: {
                  description: "new skill",
                }
              }
            }
          }

          it "returns 422 http status" do
            post path, params: params, headers: header
            expect(response).to have_http_status(:unprocessable_entity)
            expect(json["errors"][0]["status"]).to eq "422"
            expect(json["errors"][0]["detail"]).to match "empty: relationships"
          end
        end
      end
    end

    context "when user does not belong to occupation standard" do
      it_behaves_like "forbidden", :post do
        let(:os) { create(:occupation_standard) }
      end
    end
  end
end
