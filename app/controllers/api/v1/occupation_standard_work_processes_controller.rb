class API::V1::OccupationStandardWorkProcessesController < API::V1::APIController
  skip_before_action :authenticate

  def index
    @os = OccupationStandard.find(params[:occupation_standard_id])
    @oswps = @os.occupation_standard_work_processes
    options = { links: { self: @os.related_url("occupation_standard_work_processes") } }
    options[:include] = [:occupation_standard_skills]
    render json: API::V1::OccupationStandardWorkProcessSerializer.new(@oswps, options)
  end

  def show
    @oswp = OccupationStandardWorkProcess.find(params[:id])
    options = { links: { self: @oswp.url } }
    options[:include] = [:occupation_standard_skills]
    render json: API::V1::OccupationStandardWorkProcessSerializer.new(@oswp, options)
  end
end
