class API::V1::CategoriesController < API::V1::APIController
  skip_before_action :authenticate, only: [:show]

  before_action :authorize_parent, only: [:create]
  before_action :set_category, only: [:show, :update]

  def show
    render_resource
  end

  def create
    @category = Category.new(create_params)
    if @category.save
      render_resource
    else
      render_resource_error(@category)
    end
  end

  def update
    authorize [:api, :v1, @category]
    if @category.update(update_params)
      render_resource
    else
      render_resource_error(@category)
    end
  end

  private

  def set_category
    @category = Category.find_by(id: params[:id])
    head :not_found and return unless @category
  end

  def create_params
    params.require(:data).require(:attributes).permit(:name, :sort_order).merge(occupation_standard_work_process_id: @oswp.id)
  end

  def update_params
    params.require(:data).require(:attributes).permit(:name, :sort_order)
  end

  def work_process_params
    params.require(:data).require(:relationships).require(:work_process).require(:data).permit(:id)
  end

  def authorize_parent
    @oswp = OccupationStandardWorkProcess.find_by(work_process_params)
    head :not_found and return unless @oswp
    authorize [:api, :v1, @oswp], :create_category?

  rescue ActionController::ParameterMissing => e
    render_error(status: :unprocessable_entity, detail: e.message)
  end

  def render_resource
    options = {
      links: { self: @category.url },
      include: [
        :occupation_standard_skills,
        :occupation_standard_work_process,
      ]
    }
    render json: API::V1::CategorySerializer.new(@category, options)
  end
end
