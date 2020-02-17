class API::V1::Categories::RelationshipsController < API::V1::APIController
  skip_before_action :authenticate, only: [:index]
  before_action :set_category

  private

  def set_category
    @category = Category.find_by(id: params[:id])
    head :no_content and return unless @category
  end
end
