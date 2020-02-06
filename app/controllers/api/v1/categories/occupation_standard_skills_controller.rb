class API::V1::Categories::OccupationStandardSkillsController < API::V1::APIController
  skip_before_action :authenticate
  before_action :set_category

  def index
    @osss = @category.occupation_standard_skills
    options = {
      links: { self: @category.related_url("occupation_standard_skills") }
    }
    render json: API::V1::OccupationStandardSkillSerializer.new(@osss, options)
  end

  private

  def set_category
    @category = Category.find_by(id: params[:category_id])
    head :not_found and return unless @category
  end
end
