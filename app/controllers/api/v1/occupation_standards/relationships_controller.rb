class API::V1::OccupationStandards::RelationshipsController < API::V1::OccupationStandards::Relationships::BaseController

  skip_before_action :authenticate

  def work_processes
    @oswps = @os.occupation_standard_work_processes
    options = {
      links: {
        self: @os.relationships_url('work_processes'),
        related: @os.related_url('occupation_standard_work_processes'),
      }
    }
    render json: API::V1::OccupationStandard::Relationships::WorkProcessSerializer.new(@oswps, options)
  end

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
end
