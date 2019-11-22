class API::V1::OccupationStandardSkillsController < API::V1::APIController
  skip_before_action :authenticate

  def index
    @os = OccupationStandard.find(params[:occupation_standard_id])
    @osss = @os.occupation_standard_skills_with_no_work_process
    options = { links: { self: @os.related_url("occupation_standard_skills") } }
    render json: API::V1::OccupationStandardSkillSerializer.new(@osss, options)
  end

  def show
    @oss = OccupationStandardSkill.find(params[:id])
    options = { links: { self: @oss.url } }
    render json: API::V1::OccupationStandardSkillSerializer.new(@oss, options)
  end
end
