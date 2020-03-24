class API::V1::OccupationStandards::OccupationStandardSkillsController < API::V1::APIController
  skip_before_action :authenticate, only: [:index]

  before_action :set_occupation_standard, only: [:index]

  def index
    @osss = @os.occupation_standard_skills_with_no_work_process
    options = { links: { self: @os.related_url("occupation_standard_skills") } }
    render json: API::V1::OccupationStandardSkillSerializer.new(@osss, options)
  end

  private

  def set_occupation_standard
    @os = OccupationStandard.find_by(id: params[:occupation_standard_id])
    head :not_found and return unless @os
  end
end
