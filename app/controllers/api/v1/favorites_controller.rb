class API::V1::FavoritesController < API::V1::APIController
  before_action :set_target_user

  def create
    authorize [:api, :v1, @target_user], :favorite?
    os = OccupationStandard.find(object_params[:id])
    Relationship.create(user: @target_user, occupation_standard: os)
    head :ok
  end

  def destroy
    authorize [:api, :v1, @target_user], :favorite?
    os = OccupationStandard.find(object_params[:id])
    Relationship.where(user: @target_user, occupation_standard: os).destroy_all
    head :ok
  end

  private

  def set_target_user
    @target_user = User.find(params[:id])
  end

  def object_params
    params.require(:data).permit(:type, :id)
  end
end
