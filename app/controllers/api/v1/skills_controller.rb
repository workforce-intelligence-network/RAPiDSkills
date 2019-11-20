class API::V1::SkillsController < API::V1::APIController
  skip_before_action :authenticate

  def show
    @skill = Skill.find(params[:id])
    options = { links: { self: @skill.url } }
    render json: API::V1::SkillSerializer.new(@skill, options)
  end
end
