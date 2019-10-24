class API::V1::OccupationsController < ApplicationController
  def index
    @occupations = Occupation.search(params[:q]).order(id: :desc)
    render json: API::V1::OccupationSerializer.new(@occupations)
  end
end
