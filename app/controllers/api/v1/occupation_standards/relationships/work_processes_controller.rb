class API::V1::OccupationStandards::Relationships::WorkProcessesController < API::V1::OccupationStandards::Relationships::BaseController
  skip_before_action :authenticate, only: [:index]

  def index
    @oswps = @os.occupation_standard_work_processes
    options = {
      links: {
        self: @os.relationships_url('work_processes'),
        related: @os.related_url('occupation_standard_work_processes'),
      }
    }
    render json: API::V1::OccupationStandard::Relationships::WorkProcessSerializer.new(@oswps, options)
  end
end
