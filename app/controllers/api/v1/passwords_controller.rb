class API::V1::PasswordsController < API::V1::APIController
  skip_before_action :authenticate, only: :create
  before_action :set_client_session, only: :show

  def create
    @user = User.find_by(email: create_params[:email])
    @user.send_reset_password_instructions if @user
    render json: { detail: "Please check your email. If you have an account, you will receive instructions to reset in your email." }, status: 200
  end

  def update
    @user = User.find_by(reset_password_token: update_params[:reset_password_token])
    if @user.update(update_params)
      render_resource
    else
      render_resource_error(@user)
    end
  end

  private

  def create_params
    params.require(:data).require(:attributes).permit(:email)
  end

  def update_params
    params.require(:data).require(:attributes).permit(:password, :password_confirmation, :reset_password_token)
  end
end
