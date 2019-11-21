class API::V1::ClonesController < API::V1::APIController

  def create
    object_type = object_params[:type]
    object_id = object_params[:id]
    object = object_type.classify.constantize.find_by(id: object_id)

    if object
      case object_type
      when "occupation_standard"
        @os = object.clone_as_unregistered!(
          creator_id: current_user.id,
          organization_id: current_user.employer_id,
        )
        options = {
          include: [
            :"occupation_standard_work_processes.occupation_standard_skills",
            :occupation_standard_skills,
          ],
        }
        render json: API::V1::OccupationStandardSerializer.new(@os, options)
      else
        error_scope = "errors.clonable.not_acceptable"
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
    params.require(:data).require(:relationships).require(:clonable).require(:data).permit(:type, :id)
  end
end
