class API::V1::OccupationStandardsController < API::V1::APIController
  skip_before_action :authenticate, except: [:create]

  def index
    @oss = OccupationStandard
             .includes(:organization, :occupation, :industry, :pdf_attachment, :excel_attachment)
             .search(search_params.to_h)
             .order(id: :desc)
    options = { links: { self: api_v1_occupation_standards_url } }
    render json: API::V1::OccupationStandardSerializer.new(@oss, options)
  end

  def show
    @os = OccupationStandard.find(params[:id])
    options = { links: { self: @os.url } }
    options[:include] = OccupationStandard::DEFAULT_RELATIONSHIP_INCLUDE
    render json: API::V1::OccupationStandardSerializer.new(@os, options)
  end

  def create
    parent = OccupationStandard.find_by(id: create_params[:parent_occupation_standard_id])
    if parent
      @os = parent.clone_as_unregistered!(
        creator_id: current_user.id,
        organization_id: current_user.employer_id,
      )
      options = { include: OccupationStandard::DEFAULT_RELATIONSHIP_INCLUDE }
      render json: API::V1::OccupationStandardSerializer.new(@os, options)
    else
      @os = OccupationStandard.new
      @os.errors.add(:parent_occupation_standard_id, :invalid)
      render_resource_error(@os)
    end
  end

  private

  def search_params
    params.permit(:occupation_id)
  end

  def create_params
    params.require(:data).require(:attributes).permit(:parent_occupation_standard_id)
  end
end
