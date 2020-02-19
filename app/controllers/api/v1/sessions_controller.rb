class API::V1::SessionsController < API::V1::APIController
  skip_before_action :authenticate, only: :create
  before_action :set_client_session, only: :show

  def create
    @user = User.find_by(email: create_params[:email])
    if @user && @user.valid_password?(create_params[:password])
      @session = @user.create_session!
      sign_in @user
      render json: API::V1::SessionSerializer.new(@session, render_options),
        status: :created
    else
      render_error(
        status: :unprocessable_entity,
        detail: I18n.t(
          "devise.failure.not_found_in_database",
          authentication_keys: :email,
        ),
      )
    end
  end

  def show
    authorize [:api, :v1, @session]
    render json: API::V1::SessionSerializer.new(@session, render_options)
  end

  def destroy
    @user.destroy_session!(@session_identifier)
    sign_out @user
    head :no_content
  end

  private

  def create_params
    params.require(:data).require(:attributes).permit(:email, :password)
  end

  def set_client_session
    @session = ClientSession.find_by(id: params[:id])
    head :not_found and return unless @session
  end

  def render_options
    {
      include: [:user],
      links: { self: @session.url },
      meta: { access_token: @session.token, token_type: "Bearer" },
    }
  end
end
