class API::V1::OccupationStandards::RelationshipsController < API::V1::APIController
  skip_before_action :authenticate

  before_action :set_occupation_standard

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

  def skills
    @osss = @os.occupation_standard_skills_with_no_work_process
    options = {
      links: {
        self: @os.relationships_url('skills'),
        related: @os.related_url('occupation_standard_skills'),
      }
    }
    render json: API::V1::OccupationStandard::Relationships::SkillSerializer.new(@osss, options)
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

  private

  def set_occupation_standard
    @os = OccupationStandard.find(params[:id])
  end
end
