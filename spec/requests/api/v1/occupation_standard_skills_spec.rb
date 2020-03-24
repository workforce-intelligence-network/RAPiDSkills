require 'rails_helper'

RSpec.describe API::V1::OccupationStandardSkillsController, type: :request do
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
    let(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }
    let!(:oss) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp) }
    let(:header) { auth_header(user) }
    let(:params) {
      {
        data: {
          type: "skill",
          id: oss.id.to_s,
          attributes: {
            description: "this is an updated desc",
            sort_order: 99,
          }
        }
      }
    }

    context "when user belongs to occupation_standard" do
      let(:os) { create(:occupation_standard, creator: user) }

      it_behaves_like "authentication", :patch

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
            expect(oss.sort_order).to eq 99
            expect(oss.occupation_standard_work_process).to eq oswp
          end

          it "returns correct response" do
            patch path, params: params, headers: header
            expect(response).to have_http_status(:success)
            expect(json["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
            expect(json["data"]["id"]).to eq oss.id.to_s
            expect(json["data"]["type"]).to eq "skill"
            expect(json["data"]["attributes"]["description"]).to eq "this is an updated desc"
            expect(json["data"]["attributes"]["sort_order"]).to eq 99
            expect(json["data"]["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
          end

          it "triggers pdf/excel generation" do
            expect(GenerateOccupationStandardPdfJob).to receive(:perform_later).with(os.id)
            expect(GenerateOccupationStandardExcelJob).to receive(:perform_later).with(os.id)
            patch path, params: params, headers: header
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
            expect(oss.sort_order).to eq 99
            expect(oss.occupation_standard_work_process).to eq oswp
            expect(skill.reload.parent_skill).to eq parent
          end

          it "returns correct response" do
            patch path, params: params, headers: header
            expect(response).to have_http_status(:success)
            expect(json["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
            expect(json["data"]["id"]).to eq oss.id.to_s
            expect(json["data"]["type"]).to eq "skill"
            expect(json["data"]["attributes"]["description"]).to eq "this is an updated desc"
            expect(json["data"]["attributes"]["sort_order"]).to eq 99
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

        it "does not trigger pdf/excel generation" do
          expect(GenerateOccupationStandardPdfJob).to_not receive(:perform_later)
          expect(GenerateOccupationStandardExcelJob).to_not receive(:perform_later)
          patch path, params: params, headers: header
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
            sort_order: 99,
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

      it_behaves_like "authentication", :post

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
              expect(oss.sort_order).to eq 99
            end

            it "returns correct response" do
              post path, params: params, headers: header
              expect(response).to have_http_status(:success)
              oss = OccupationStandardSkill.last
              expect(json["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
              expect(json["data"]["id"]).to eq oss.id.to_s
              expect(json["data"]["type"]).to eq "skill"
              expect(json["data"]["attributes"]["description"]).to eq "this is a new skill"
              expect(json["data"]["attributes"]["sort_order"]).to eq 99
              expect(json["data"]["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
            end

            it "triggers pdf/excel generation" do
              expect(GenerateOccupationStandardPdfJob).to receive(:perform_later).with(os.id)
              expect(GenerateOccupationStandardExcelJob).to receive(:perform_later).with(os.id)
              post path, params: params, headers: header
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
              expect(oss.sort_order).to eq 99
            end

            it "returns correct response" do
              post path, params: params, headers: header
              oss = OccupationStandardSkill.last
              expect(response).to have_http_status(:success)
              expect(json["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
              expect(json["data"]["id"]).to eq oss.id.to_s
              expect(json["data"]["type"]).to eq "skill"
              expect(json["data"]["attributes"]["description"]).to eq "this is a new skill"
              expect(json["data"]["attributes"]["sort_order"]).to eq 99
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
                  sort_order: 99,
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
              expect(oss.sort_order).to eq 99
            end

            it "returns correct response" do
              post path, params: params, headers: header
              expect(response).to have_http_status(:success)
              oss = OccupationStandardSkill.last
              expect(json["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
              expect(json["data"]["id"]).to eq oss.id.to_s
              expect(json["data"]["type"]).to eq "skill"
              expect(json["data"]["attributes"]["description"]).to eq "this is a new skill"
              expect(json["data"]["attributes"]["sort_order"]).to eq 99
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

        context "when passing category parent" do
          let(:params) {
            {
              data: {
                type: "skill",
                attributes: {
                  description: "this is a new skill",
                },
                relationships: {
                  category: {
                    data: {
                      type: "category",
                      id: category.id.to_s,
                    }
                  }
                }
              }
            }
          }

          context "when category belongs to standard" do
            let(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }
            let(:category) { create(:category, occupation_standard_work_process: oswp) }

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
              expect(oss.category).to eq category
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

          context "when category does not belong to standard" do
            let(:category) { create(:category) }

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

          it "does not trigger pdf/excel generation" do
            expect(GenerateOccupationStandardPdfJob).to_not receive(:perform_later)
            expect(GenerateOccupationStandardExcelJob).to_not receive(:perform_later)
            post path, params: params, headers: header
          end

          it "returns 422 with an error message" do
            post path, params: params, headers: header
            expect(response).to have_http_status(:unprocessable_entity)
            expect(json["errors"][0]["status"]).to eq "422"
            expect(json["errors"][0]["detail"]).to eq "Description can't be blank"
          end
        end

        context "with bad standard, work process, and category ids" do
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
                    },
                    category: {
                      data: {
                        type: "category",
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
