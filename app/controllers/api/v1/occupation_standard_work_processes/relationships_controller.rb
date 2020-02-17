class API::V1::OccupationStandardWorkProcesses::RelationshipsController < API::V1::APIController
  skip_before_action :authenticate, only: [:index]
  before_action :set_occupation_standard_work_process

  private

  def set_occupation_standard_work_process
    @oswp = OccupationStandardWorkProcess.find_by(id: params[:id])
    head :no_content and return unless @oswp
  end
end
