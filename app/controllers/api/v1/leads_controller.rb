class API::V1::LeadsController < API::V1::APIController
  skip_before_action :authenticate, only: :create

  def create
    @user = User.find_for_database_authentication(email: user_params[:email])
    unless @user
      @user = User.new(user_params)
      @user.password = SecureRandom.uuid
    end

    if @user.new_record?
      @user.employer = Organization.where(
        title: organization_params[:organization_title]
      ).first_or_initialize
    end

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
    params.require(:data).require(:attributes).permit(:email, :name)
  end

  def organization_params
    params.require(:data).require(:attributes).permit(:organization_title)
  end
end
