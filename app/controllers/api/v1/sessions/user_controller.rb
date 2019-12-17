class API::V1::Sessions::UserController < API::V1::APIController
  before_action :set_client_session

  def show
    authorize [:api, :v1, @session]
    options = { links: { self: @session.related_url('user') } }
    render json: API::V1::UserSerializer.new(@user, options)
  end

  private

  def set_client_session
    @session = ClientSession.find_by(id: params[:client_session_id])
    head :not_found and return unless @session
  end
end
