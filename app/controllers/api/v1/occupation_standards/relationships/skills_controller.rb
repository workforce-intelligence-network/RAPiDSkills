class API::V1::OccupationStandards::Relationships::SkillsController < API::V1::OccupationStandards::Relationships::BaseController
  skip_before_action :authenticate, only: [:index]

  def index
    @osss = @os.occupation_standard_skills_with_no_work_process
    options = {
      links: {
        self: @os.relationships_url('skills'),
        related: @os.related_url('occupation_standard_skills'),
      }
    }
    render json: API::V1::OccupationStandard::Relationships::SkillSerializer.new(@osss, options)
  end

  def destroy
    authorize @os, :delete_skill?, policy_class: API::V1::OccupationStandardPolicy
    object_params.each do |object_param|
      oss = OccupationStandardSkill.find_by(id: object_param[:id])
      oss.destroy
    end
    head :no_content
  end

  private

  def object_params
    params.require(:data)
  end
end
