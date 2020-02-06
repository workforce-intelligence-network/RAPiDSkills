class API::V1::OccupationStandardWorkProcesses::Relationships::SkillsController < API::V1::OccupationStandardWorkProcesses::RelationshipsController
  def index
    @osss = @oswp.occupation_standard_skills
    options = {
      links: {
        self: @oswp.relationships_url('skills'),
        related: @oswp.related_url('occupation_standard_skills'),
      }
    }
    render json: API::V1::Relationships::OccupationStandardSkillSerializer.new(@osss, options)
  end
end
