class API::V1::OccupationStandardWorkProcessesController < API::V1::APIController
  skip_before_action :authenticate, only: [:index, :show]
  before_action :set_occupation_standard, only: [:index]
  before_action :set_occupation_standard_work_process, only: [:show, :update]

  def index
    @oswps = @os.occupation_standard_work_processes.with_eager_loading
    options = { links: { self: @os.related_url("occupation_standard_work_processes") } }
    options[:include] = [:occupation_standard_skills]
    render json: API::V1::OccupationStandardWorkProcessSerializer.new(@oswps, options)
  end

  def show
    render_resource
  end

  def create
    @os = OccupationStandard.where(id: occupation_standard_params[:id]).first_or_initialize
    authorize @os, :create_work_process?, policy_class: API::V1::OccupationStandardPolicy
    work_process = WorkProcess.where(update_params).first_or_initialize
    if work_process.save
      @oswp = @os.occupation_standard_work_processes.where(work_process: work_process).first_or_create
      render_resource
    else
      render_resource_error(work_process)
    end

  rescue ActionController::ParameterMissing => e
    render_error(status: :unprocessable_entity, detail: e.message)
  end

  def update
    authorize [:api, :v1, @oswp]
    work_process = WorkProcess.where(update_params).first_or_initialize
    if work_process.save
      @oswp.update(work_process: work_process)
      render_resource
    else
      render_resource_error(work_process)
    end
  end

  private

  def set_occupation_standard
    @os = OccupationStandard.find_by(id: params[:occupation_standard_id])
    head :not_found and return unless @os
  end

  def set_occupation_standard_work_process
    @oswp = OccupationStandardWorkProcess.find_by(id: params[:id])
    head :not_found and return unless @oswp
  end

  def occupation_standard_params
    params.require(:data).require(:relationships).require(:occupation_standard).require(:data).permit(:id)
  end

  def update_params
    params.require(:data).require(:attributes).permit(:title, :description)
  end

  def render_resource
    options = { links: { self: @oswp.url } }
    options[:include] = [:occupation_standard_skills]
    render json: API::V1::OccupationStandardWorkProcessSerializer.new(@oswp, options)
  end
end
