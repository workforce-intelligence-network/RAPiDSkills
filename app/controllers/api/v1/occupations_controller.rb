class API::V1::OccupationsController < API::V1::APIController
  skip_before_action :authenticate, only: :index

  def index
    @occupations = Occupation.search_records(q: params[:q])
    render json: API::V1::OccupationSerializer.new(@occupations)
  end
end
