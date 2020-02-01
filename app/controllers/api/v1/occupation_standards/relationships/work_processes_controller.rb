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

  def destroy
    authorize @os, :delete_work_process?, policy_class: API::V1::OccupationStandardPolicy
    object_params.each do |object_param|
      oswp = OccupationStandardWorkProcess.find_by(id: object_param[:id])
      oswp.destroy
    end
    head :no_content
  end

  private

  def object_params
    params.require(:data)
  end
end
