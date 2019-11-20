require 'rails_helper'

RSpec.describe API::V1::OccupationStandardSkillsController, type: :request do
  describe "GET #show" do
    let(:path) { "/api/v1/skills/#{oss.id}" }

    let(:oss) { create(:occupation_standard_skill) }

    it "returns the correct data" do
      get path
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq api_v1_occupation_standard_skill_url(oss)
      expect(json["data"]["id"]).to eq oss.id.to_s
      expect(json["data"]["type"]).to eq "skill"
      expect(json["data"]["attributes"]["description"]).to eq oss.skill.description
    end
  end
end
