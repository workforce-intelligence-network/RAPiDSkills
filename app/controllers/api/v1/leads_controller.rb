class API::V1::LeadsController < API::V1::APIController
  skip_before_action :authenticate, only: :create

  def create
    @user = User.where(
      email: user_params[:email]
    ).first_or_initialize(
      name: user_params[:name],
      password: SecureRandom.uuid,
    )

    if @user.new_record?
      @user.employer = Organization.where(
        title: organization_params[:organization_name]
      ).first_or_initialize
    end

    if @user.save
      options = {}
      options[:include] = [:employer] if @user.employer.persisted?
      render json: API::V1::UserSerializer.new(@user, options), status: :created
    else
      render_resource_error(@user)
    end
  end

  private

  def user_params
    params.require(:data).require(:attributes).permit(:email, :name)
  end

  def organization_params
    params.require(:data).require(:attributes).permit(:organization_name)
  end
end
