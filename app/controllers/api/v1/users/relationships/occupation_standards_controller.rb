class API::V1::Users::Relationships::OccupationStandardsController < API::V1::Users::Relationships::BaseController

  def index
    authorize [:api, :v1, @target_user], :occupation_standard?
    @occupation_standards = @target_user.occupation_standards.order(id: :desc)
    options = {
      links: {
        self: @target_user.relationships_url('occupation_standards'),
        related: @target_user.related_url('occupation_standards'),
      }
    }
    render json: API::V1::User::Relationships::OccupationStandardSerializer.new(@occupation_standards, options)
  end
end
