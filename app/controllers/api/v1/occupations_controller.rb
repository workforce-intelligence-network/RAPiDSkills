class API::V1::OccupationsController < API::V1::APIController
  skip_before_action :authenticate, only: :index

  def index
    @occupations = Occupation.search_records(search_params.to_h)
    render json: API::V1::OccupationSerializer.new(@occupations)
  end

  private

  def search_params
    params.permit(:q)
  end
end
