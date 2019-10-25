class API::V1::OccupationStandardsController < ApplicationController
  def index
    @oss = OccupationStandard
             .includes(:organization, :occupation, :industry)
             .filter_collection(filter_params.to_h)
             .order(id: :desc)
    render json: API::V1::OccupationStandardSerializer.new(@oss)
  end

  private

  def filter_params
    params.permit(:occupation_id)
  end
end
