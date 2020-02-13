require 'rails_helper'

RSpec.describe API::V1::OccupationStandards::RelationshipsController, type: :request do
  describe "GET #occupation" do
    let(:path) { "/api/v1/occupation_standards/#{os.id}/relationships/occupation" }
    let(:occupation) { create(:occupation) }
    let(:os) { create(:occupation_standard, occupation: occupation) }

    it "returns the correct data" do
      get path
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq relationships_occupation_api_v1_occupation_standard_url(os)
      expect(json["links"]["related"]).to eq api_v1_occupation_url(occupation)
      expect(json["data"]["type"]).to eq "occupation"
      expect(json["data"]["id"]).to eq occupation.id.to_s
    end
  end

  describe "GET #organization" do
    let(:path) { "/api/v1/occupation_standards/#{os.id}/relationships/organization" }
    let(:organization) { create(:organization) }
    let(:os) { create(:occupation_standard, organization: organization) }

    it "returns the correct data" do
      get path
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq relationships_organization_api_v1_occupation_standard_url(os)
      expect(json["links"]["related"]).to eq api_v1_organization_url(organization)
      expect(json["data"]["type"]).to eq "organization"
      expect(json["data"]["id"]).to eq organization.id.to_s
    end
  end
end
