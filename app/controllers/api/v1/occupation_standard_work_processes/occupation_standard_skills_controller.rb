class API::V1::OccupationStandardWorkProcesses::OccupationStandardSkillsController < API::V1::APIController
  skip_before_action :authenticate

  def index
    @oswp = OccupationStandardWorkProcess.find(params[:occupation_standard_work_process_id])
    @osss = @oswp.occupation_standard_skills
    options = { links: { self: @oswp.related_url("occupation_standard_skills") } }
    render json: API::V1::OccupationStandardSkillSerializer.new(@osss, options)
  end
end
