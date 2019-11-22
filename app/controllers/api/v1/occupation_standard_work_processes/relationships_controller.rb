class API::V1::OccupationStandardWorkProcesses::RelationshipsController < API::V1::APIController
  skip_before_action :authenticate

  before_action :set_occupation_standard_work_process

  def skills
    @skills = @oswp.skills
    options = {
      links: {
        self: @oswp.relationships_url('skills'),
        related: @oswp.related_url('occupation_standard_skills'),
      }
    }
    render json: API::V1::OccupationStandardWorkProcess::Relationships::SkillSerializer.new(@skills, options)
  end

  private

  def set_occupation_standard_work_process
    @oswp = OccupationStandardWorkProcess.find(params[:id])
  end
end
