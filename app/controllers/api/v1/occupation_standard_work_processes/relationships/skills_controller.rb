class API::V1::OccupationStandardWorkProcesses::Relationships::SkillsController < API::V1::OccupationStandardWorkProcesses::RelationshipsController
  def index
    @skills = @oswp.skills
    options = {
      links: {
        self: @oswp.relationships_url('skills'),
        related: @oswp.related_url('occupation_standard_skills'),
      }
    }
    render json: API::V1::OccupationStandardWorkProcess::Relationships::SkillSerializer.new(@skills, options)
  end
end
