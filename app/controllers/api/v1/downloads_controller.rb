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
        error_scope = "errors.downloadable.not_acceptable"
        render_error(
          status: :not_acceptable,
          title: I18n.t(:title, type: object_type, scope: error_scope),
          detail: I18n.t(:detail, scope: error_scope),
          source_pointer: I18n.t(:source_pointer, scope: error_scope),
        )
      end
    else
      head :not_found
    end

  rescue ActionController::ParameterMissing => e
    render_error(status: :unprocessable_entity, detail: e.message)
  end

  private

  def object_params
    params.require(:data).require(:relationships).require(:downloadable).require(:data).permit(:type, :id)
  end
end
