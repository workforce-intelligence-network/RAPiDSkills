class API::V1::OccupationStandardWorkProcesses::OccupationStandardSkillsController < API::V1::APIController
  skip_before_action :authenticate
  before_action :set_occupation_standard_work_process

  def index
    @osss = @oswp.occupation_standard_skills
    options = { links: { self: @oswp.related_url("occupation_standard_skills") } }
    render json: API::V1::OccupationStandardSkillSerializer.new(@osss, options)
  end

  private

  def set_occupation_standard_work_process
    @oswp = OccupationStandardWorkProcess.find_by(id: params[:occupation_standard_work_process_id])
    head :not_found and return unless @oswp
  end
end
