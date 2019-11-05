class API::V1::UsersController < API::V1::APIController
  def create
    @user = User.where(
      email: params[:data][:attributes][:email]
    ).first_or_initialize(password: SecureRandom.uuid) # tmp pw for now
    @user.employer = Organization.where(title: params[:data][:attributes][:organization_name]).first_or_initialize
    if @user.update(user_params)
      options = {}
      options[:include] = [:employer] if @user.employer.persisted?
      render json: API::V1::UserSerializer.new(@user, options)
    else
      render_resource_error(@user)
    end
  end

  private

  def user_params
    params.require(:data).require(:attributes).permit(:name)
  end
end
