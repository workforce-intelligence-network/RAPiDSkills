class API::V1::UsersController < API::V1::APIController
  skip_before_action :authenticate, only: :create

  def create
    @user = User.new(user_params)
    @user.employer = Organization.where(
      title: organization_params[:organization_title]
    ).first_or_initialize
    @user.role = :basic

    if @user.save
      options = {}
      options[:include] = [:employer] if @user.employer.persisted?
      render json: API::V1::UserSerializer.new(@user, options), status: :created
    else
      render_resource_error(@user)
    end

  rescue ActionController::ParameterMissing => e
    render_error(status: :unprocessable_entity, detail: e.message)
  end

  private

  def user_params
    params.require(:data).require(:attributes).permit(:name, :email, :password)
  end

  def organization_params
    params.require(:data).require(:attributes).permit(:organization_title)
  end
end
