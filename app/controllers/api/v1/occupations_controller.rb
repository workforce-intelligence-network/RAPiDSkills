class API::V1::OccupationsController < API::V1::APIController
  def index
    @occupations = Occupation.search(search_params.to_h).order(id: :desc)
    render json: API::V1::OccupationSerializer.new(@occupations)
  end

  private

  def search_params
    params.permit(:q)
  end
end
