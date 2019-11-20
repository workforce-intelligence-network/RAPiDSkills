class API::V1::OccupationStandardSkillsController < API::V1::APIController
  skip_before_action :authenticate

  def show
    @oss = OccupationStandardSkill.find(params[:id])
    options = { links: { self: @oss.url } }
    render json: API::V1::OccupationStandardSkillSerializer.new(@oss, options)
  end
end
