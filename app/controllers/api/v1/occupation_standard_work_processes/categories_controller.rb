class API::V1::OccupationStandardWorkProcesses::CategoriesController < API::V1::APIController
  skip_before_action :authenticate

  def index
    @oswp = OccupationStandardWorkProcess.find(params[:occupation_standard_work_process_id])
    @categories = @oswp.categories
    options = { links: { self: @oswp.related_url("categories") } }
    render json: API::V1::CategorySerializer.new(@categories, options)
  end
end
