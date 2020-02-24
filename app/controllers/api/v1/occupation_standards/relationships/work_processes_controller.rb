class API::V1::OccupationStandards::Relationships::WorkProcessesController < API::V1::OccupationStandards::Relationships::BaseController
  skip_before_action :authenticate, only: [:index]
  after_action :generate_download_docs, only: :destroy, if: -> { response.successful? }

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
    begin
      OccupationStandardWorkProcess.transaction do
        object_params.each_with_index do |object_param, index|
          @pointer = "/data/#{index}"
          oswp = @os.occupation_standard_work_processes.find_by(id: object_param[:id])
          oswp.destroy if oswp
        end
      end
      head :no_content
    rescue Exception => e
      render_error(
        status: :unprocessable_entity,
        detail: "Work process with skills may not be deleted",
        source_pointer: @pointer,
      )
    end
  end

  private

  def object_params
    params.require(:data)
  end

  def generate_download_docs
    @os.generate_download_docs
  end
end
