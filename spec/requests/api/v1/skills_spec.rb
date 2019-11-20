require 'rails_helper'

RSpec.describe API::V1::SkillsController, type: :request do
  describe "GET #show" do
    let(:path) { "/api/v1/skills/#{skill.id}" }

    let(:skill) { create(:skill) }

    it "returns the correct data" do
      get path
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq api_v1_skill_url(skill)
      expect(json["data"]["id"]).to eq skill.id.to_s
      expect(json["data"]["type"]).to eq "skill"
      expect(json["data"]["attributes"]["description"]).to eq skill.description
    end
  end
end
