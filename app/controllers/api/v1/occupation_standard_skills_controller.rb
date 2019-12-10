class API::V1::OccupationStandardSkillsController < API::V1::APIController
  skip_before_action :authenticate, only: [:index, :show]

  before_action :set_occupation_standard_skill, only: [:show, :update]

  def index
    @os = OccupationStandard.find(params[:occupation_standard_id])
    @osss = @os.occupation_standard_skills_with_no_work_process
    options = { links: { self: @os.related_url("occupation_standard_skills") } }
    render json: API::V1::OccupationStandardSkillSerializer.new(@osss, options)
  end

  def show
    render_resource
  end

  def update
    authorize [:api, :v1, @oss]
    skill = Skill.where(update_params).first_or_initialize(parent_skill: @oss.skill)
    if skill.save
      @oss.update(skill: skill)
      render_resource
    else
      render_resource_error(skill)
    end
  end

  private

  def set_occupation_standard_skill
    @oss = OccupationStandardSkill.find(params[:id])
  end

  def update_params
    params.require(:data).require(:attributes).permit(:description)
  end

  def render_resource
    options = { links: { self: @oss.url } }
    render json: API::V1::OccupationStandardSkillSerializer.new(@oss, options)
  end
end
