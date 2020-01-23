class API::V1::Users::OccupationStandardsController < API::V1::Users::BaseController

  def index
    authorize [:api, :v1, @target_user], :occupation_standard?
    @occupation_standards = @target_user.occupation_standards.order(id: :desc).with_eager_loading
    options = {
      links: { self: api_v1_user_occupation_standards_url(@target_user) }
    }
    render json: API::V1::OccupationStandardSerializer.new(@occupation_standards, options)
  end
end
