class API::V1::DownloadsController < API::V1::APIController
  skip_before_action :authenticate, only: :create

  def create
    object_type = object_params[:type]
    object_id = object_params[:id]
    object = object_type.classify.constantize.find_by(id: object_id)

    if object
      case object_type
      when "occupation_standard"
        GenerateOccupationStandardPdfJob.perform_later(object_id)
        GenerateOccupationStandardExcelJob.perform_later(object_id)
        head :accepted
      else
        render json: {
          errors: [
            {
              status: "406",
              title: "Records of type #{object_type} are not downloadable",
              detail: "Valid downloadable record types include: occupation_standard",
              source: { pointer: "/data/relationships/downloadable/data/type" },
            }
          ]
        }, status: :not_acceptable
      end
    else
      head :not_found
    end

  rescue ActionController::ParameterMissing => e
    render json: {
      errors: [
        {
          status: "422",
          detail: e.message,
        }
      ]
    }, status: :unprocessable_entity
  end

  private

  def object_params
    params.require(:data).require(:relationships).require(:downloadable).require(:data).permit(:type, :id)
  end
end
