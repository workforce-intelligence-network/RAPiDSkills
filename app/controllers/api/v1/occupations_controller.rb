class API::V1::OccupationsController < ApplicationController
  def index
    @occupations = Occupation.search(search_params.to_h).order(id: :desc)
    render json: API::V1::OccupationSerializer.new(@occupations)
  end

  private

  def search_params
    params.permit(:q)
  end
end
