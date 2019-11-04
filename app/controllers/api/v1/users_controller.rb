class API::V1::UsersController < API::V1::APIController
  def create
    @user = User.where(
      email: params[:data][:attributes][:email]
    ).first_or_initialize(password: SecureRandom.uuid) # tmp pw for now
    if @user.update(user_params)
      render json: API::V1::UserSerializer.new(@user)
    else
      render_resource_error(@user)
    end
  end

  private

  def user_params
    params.require(:data).require(:attributes).permit(:name)
  end
end
