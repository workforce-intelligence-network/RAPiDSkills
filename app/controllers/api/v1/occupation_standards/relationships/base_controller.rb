class API::V1::OccupationStandards::Relationships::BaseController < API::V1::APIController
  before_action :set_occupation_standard

  private

  def set_occupation_standard
    @os = OccupationStandard.find_by(id: params[:id])
    head :not_found and return unless @os
  end
end
