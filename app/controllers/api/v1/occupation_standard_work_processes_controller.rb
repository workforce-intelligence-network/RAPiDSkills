class API::V1::OccupationStandardWorkProcessesController < API::V1::APIController
  skip_before_action :authenticate, only: [:index, :show]
  before_action :set_occupation_standard, only: [:index]
  before_action :set_occupation_standard_work_process, only: [:show, :update]
  before_action :authorize_parent, only: [:create]
  after_action :generate_download_docs, only: [:create, :update], if: -> { response.successful? }

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
    @oswp = @os.occupation_standard_work_processes.build
    save_and_update_work_process
  end

  def update
    authorize [:api, :v1, @oswp]
    save_and_update_work_process
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

  def authorize_parent
    @os = OccupationStandard.where(id: occupation_standard_params[:id]).first_or_initialize
    authorize @os, :create_work_process?, policy_class: API::V1::OccupationStandardPolicy

  rescue ActionController::ParameterMissing => e
    render_error(status: :unprocessable_entity, detail: e.message)
  end

  def occupation_standard_params
    params.require(:data).require(:relationships).require(:occupation_standard).require(:data).permit(:id)
  end

  def work_process_params
    params.require(:data).require(:attributes).permit(:title, :description)
  end

  def oswp_params
    params.require(:data).require(:attributes).permit(:hours, :sort_order)
  end

  def save_and_update_work_process
    work_process = WorkProcess.where(work_process_params).first_or_initialize
    if work_process.save
      @oswp.assign_attributes(oswp_params)
      @oswp.update(work_process: work_process)
      render_resource
    else
      render_resource_error(work_process)
    end

  rescue ActionController::ParameterMissing => e
    render_error(status: :unprocessable_entity, detail: e.message)
  end

  def render_resource
    options = { links: { self: @oswp.url } }
    options[:include] = [:occupation_standard_skills]
    render json: API::V1::OccupationStandardWorkProcessSerializer.new(@oswp, options)
  end

  def generate_download_docs
    @oswp.occupation_standard.generate_download_docs
  end
end
