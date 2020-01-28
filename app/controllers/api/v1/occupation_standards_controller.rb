class API::V1::OccupationStandardsController < API::V1::APIController
  skip_before_action :authenticate, only: [:index, :show]
  before_action :set_occupation_standard, only: [:show, :update, :destroy]

  def index
    @oss = OccupationStandard.with_eager_loading
             .search(search_params.to_h)
             .order(id: :desc)
             .page(page_params[:number])
             .per(page_params[:size])

    options = API::V1::PaginationLinkGenerator.new(
      request: request,
      query_params: query_params,
      total_pages: @oss.total_pages,
    ).call()
    render_resource(@oss, options)
  end

  def show
    options = { links: { self: request.original_url } }
    render_resource(@os, options)
  end

  def create
    parent = OccupationStandard.find_by(id: create_params[:parent_occupation_standard_id])
    if parent
      @os = parent.clone_as_unregistered!(
        creator_id: current_user.id,
        organization_id: current_user.employer_id,
      )
      render_resource(@os)
    else
      @os = OccupationStandard.new
      @os.errors.add(:parent_occupation_standard_id, :invalid)
      render_resource_error(@os)
    end

  rescue ActionController::ParameterMissing => e
    render_error(status: :unprocessable_entity, detail: e.message)
  end

  def update
    authorize @os, policy_class: API::V1::OccupationStandardPolicy
    if organization_params[:organization_title].present?
      @os.organization = Organization.where(
        title: organization_params[:organization_title]
      ).first_or_initialize
    end
    if @os.update(update_params)
      options = { links: { self: request.original_url } }
      render_resource(@os, options)
    else
      render_resource_error(@os)
    end

  rescue ActionController::ParameterMissing => e
    render_error(status: :unprocessable_entity, detail: e.message)
  end

  def destroy
    authorize @os, policy_class: API::V1::OccupationStandardPolicy
    @os.destroy
    head :no_content
  end

  private

  def set_occupation_standard
    @os = OccupationStandard.find_by(id: params[:id])
    head :not_found and return unless @os
  end

  def search_params
    params.permit(:occupation_id)
  end

  def create_params
    params.require(:data).require(:attributes).permit(:parent_occupation_standard_id)
  end

  def update_params
    params.require(:data).require(:attributes).permit(:title, :registration_organization_name, :registration_state_id, :occupation_id, :industry_id)
  end

  def organization_params
    params.require(:data).require(:attributes).permit(:organization_title)
  end

  def page_params
    params.fetch(:page, {}).permit(:number, :size)
  end

  def query_params
    params.permit(:occupation_id, page: {})
  end

  def render_resource(record, options={})
    options[:include] = [
      :occupation,
      :"occupation_standard_work_processes.occupation_standard_skills",
      :occupation_standard_skills,
      :organization,
    ]
    render json: API::V1::OccupationStandardSerializer.new(record, options)
  end
end
