class API::V1::OccupationStandardSkillsController < API::V1::APIController
  skip_before_action :authenticate, only: [:index, :show]

  before_action :set_occupation_standard, only: [:index]
  before_action :set_occupation_standard_skill, only: [:show, :update]

  def index
    @osss = @os.occupation_standard_skills_with_no_work_process
    options = { links: { self: @os.related_url("occupation_standard_skills") } }
    render json: API::V1::OccupationStandardSkillSerializer.new(@osss, options)
  end

  def show
    render_resource
  end

  def create
    @os = OccupationStandard.where(id: occupation_standard_params[:id]).first_or_initialize
    authorize @os, :create_skill?, policy_class: API::V1::OccupationStandardPolicy
    @oswp = OccupationStandardWorkProcess.find_by(id: work_process_params[:id])
    authorize [:api, :v1, @oswp], :create_skill? if @oswp
    skill = Skill.where(update_params).first_or_initialize
    if skill.save
      @oss = @os.occupation_standard_skills.where(
        skill: skill,
        occupation_standard_work_process: @oswp,
      ).first_or_create
      render_resource
    else
      render_resource_error(skill)
    end

  rescue ActionController::ParameterMissing => e
    render_error(status: :unprocessable_entity, detail: e.message)
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

  def set_occupation_standard
    @os = OccupationStandard.find_by(id: params[:occupation_standard_id])
    head :not_found and return unless @os
  end

  def set_occupation_standard_skill
    @oss = OccupationStandardSkill.find_by(id: params[:id])
    head :not_found and return unless @oss
  end

  def update_params
    params.require(:data).require(:attributes).permit(:description)
  end

  def occupation_standard_params
    params.require(:data).require(:relationships).require(:occupation_standard).require(:data).permit(:id)
  end

  def work_process_params
    params.require(:data).require(:relationships).fetch(:work_process, {}).fetch(:data, {}).permit(:id)
  end

  def render_resource
    options = { links: { self: @oss.url } }
    render json: API::V1::OccupationStandardSkillSerializer.new(@oss, options)
  end
end
