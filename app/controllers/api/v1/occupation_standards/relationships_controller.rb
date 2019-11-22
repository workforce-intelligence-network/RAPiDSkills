class API::V1::OccupationStandards::RelationshipsController < API::V1::APIController
  skip_before_action :authenticate

  before_action :set_occupation_standard

  def work_processes
    @oswps = @os.occupation_standard_work_processes.includes(:work_process)
    options = {
      links: {
        self: @os.relationships_url('work_processes'),
        related: @os.related_url('occupation_standard_work_processes'),
      }
    }
    render json: API::V1::OccupationStandard::Relationships::WorkProcessSerializer.new(@oswps, options)
  end

  private

  def set_occupation_standard
    @os = OccupationStandard.find(params[:id])
  end
end
