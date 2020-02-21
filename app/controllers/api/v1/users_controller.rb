class API::V1::UsersController < API::V1::APIController
  skip_before_action :authenticate, only: :create

  ## TODO remove support for leads overriding passwords once the site 
  ## is opened up to anyone.
  def create
    existing_user = User.find_by(email: user_params[:email])
    if existing_user&.joined? || existing_user.nil? 
      @user = User.new ## Default behavior
    else 
      @user = existing_user ## Lead that hasnt created their own password
    end
    @user.assign_attributes(user_params)
    @user.employer = Organization.where(
      title: organization_params[:organization_title]
    ).first_or_initialize
    @user.role = :basic

    if @user.save
      sign_in @user ## Trigger bump in sign in counts, last_sign_in_at, etc
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
© 2020 GitHub