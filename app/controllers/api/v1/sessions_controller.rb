class API::V1::SessionsController < API::V1::APIController
  skip_before_action :authenticate, only: :create

  def create
    @user = User.find_by(email: params[:data][:attributes][:email])
    if @user && @user.valid_password?(params[:data][:attributes][:password])
      token = @user.create_api_access_token!
      render json: {
        meta: {
          access_token: token,
          token_type: "Bearer",
        }
      }, status: :created
    else
      render json: {
        errors: [
          {
            status: "422",
            detail: I18n.t("devise.failure.not_found_in_database", authentication_keys: :email),
          }
        ]
      }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy_session!(@session_identifier)
    head :no_content
  end
end
