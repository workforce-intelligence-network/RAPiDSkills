class API::V1::Users::FavoritesController < API::V1::APIController
  before_action :set_target_user

  def index
    authorize [:api, :v1, @target_user], :favorite?
    @favorites = @target_user.favorites.with_eager_loading
    options = { links: { self: api_v1_user_favorites_url(@target_user) } }
    render json: API::V1::OccupationStandardSerializer.new(@favorites, options)
  end

  private

  def set_target_user
    @target_user = User.find_by(id: params[:user_id])
    head :not_found and return unless @target_user
  end
end