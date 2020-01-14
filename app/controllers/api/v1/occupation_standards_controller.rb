class API::V1::OccupationStandardsController < API::V1::APIController
  skip_before_action :authenticate, except: [:create]

  def index
    params[:page] ||= {}
    @oss = OccupationStandard.with_eager_loading
             .search(search_params.to_h)
             .order(id: :desc)
             .page(params[:page][:number])
             .per(params[:page][:size])

    options = { links: { self: api_v1_occupation_standards_url } }
    render_resource(@oss, options)
  end

  def show
    @os = OccupationStandard.find(params[:id])
    options = { links: { self: @os.url } }
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
  end

  private

  def search_params
    params.permit(:occupation_id)
  end

  def create_params
    params.require(:data).require(:attributes).permit(:parent_occupation_standard_id)
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
