class API::V1::Users::FavoritesController < API::V1::Users::BaseController

  def index
    authorize [:api, :v1, @target_user], :favorite?
    @favorites = @target_user.favorites.with_eager_loading
                   .search(filter_params.to_h)
    options = { links: { self: request.original_url } }
    render json: API::V1::OccupationStandardSerializer.new(@favorites, options)
  end

  private

  def filter_params
    params.fetch(:filter, {}).permit(:creator)
  end
end
