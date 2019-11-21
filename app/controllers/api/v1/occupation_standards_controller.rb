class API::V1::OccupationStandardsController < API::V1::APIController
  skip_before_action :authenticate

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

  private

  def search_params
    params.permit(:occupation_id)
  end
end
