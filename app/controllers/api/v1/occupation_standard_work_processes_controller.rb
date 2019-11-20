class API::V1::OccupationStandardWorkProcessesController < API::V1::APIController
  skip_before_action :authenticate

  def show
    @oswp = OccupationStandardWorkProcess.find(params[:id])
    options = { links: { self: @oswp.url } }
    options[:include] = [:skills]
    render json: API::V1::OccupationStandardWorkProcessSerializer.new(@oswp, options)
  end
end
