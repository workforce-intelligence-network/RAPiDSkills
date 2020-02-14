class API::V1::OccupationStandards::RelationshipsController < API::V1::OccupationStandards::Relationships::BaseController

  skip_before_action :authenticate

  def occupation
    @occupation = @os.occupation
    options = {
      links: {
        self: @os.relationships_url('occupation'),
        related: api_v1_occupation_url(@occupation),
      }
    }
    render json: API::V1::OccupationStandard::Relationships::OccupationSerializer.new(@occupation, options)
  end

  def organization
    @organization = @os.organization
    options = {
      links: {
        self: @os.relationships_url('organization'),
        related: api_v1_organization_url(@organization),
      }
    }
    render json: API::V1::OccupationStandard::Relationships::OrganizationSerializer.new(@organization, options)
  end

  def parent_occupation_standard
    @parent = @os.parent_occupation_standard
    options = {
      links: {
        self: @os.relationships_url('parent_occupation_standard'),
        related: api_v1_occupation_standard_url(@parent),
      }
    }
    render json: API::V1::OccupationStandard::Relationships::ParentOccupationStandardSerializer.new(@parent, options)
  end
end
