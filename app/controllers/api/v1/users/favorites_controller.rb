class API::V1::Users::FavoritesController < API::V1::APIController
  def index
    @target_user = User.where(id: params[:user_id]).first_or_initialize
    authorize [:api, :v1, @target_user], :favorite?
    @favorites = @target_user.favorites.with_eager_loading
    options = { links: { self: api_v1_user_favorites_url(@target_user) } }
    render json: API::V1::OccupationStandardSerializer.new(@favorites, options)
  end
end
