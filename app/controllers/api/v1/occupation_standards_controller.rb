class API::V1::OccupationStandardsController < API::V1::APIController
  skip_before_action :authenticate, only: :index

  def index
    @oss = OccupationStandard
             .includes(:organization, :occupation, :industry)
             .search(search_params.to_h)
             .order(id: :desc)
    render json: API::V1::OccupationStandardSerializer.new(@oss)
  end

  private

  def search_params
    params.permit(:occupation_id)
  end
end
