class API::V1::Sessions::RelationshipsController < API::V1::SessionsController
  before_action :set_client_session

  def user
    authorize [:api, :v1, @session]
    options = {
      links: {
        self: @session.relationships_url('user'),
        related: @session.related_url('user'),
      }
    }
    render json: API::V1::Session::Relationships::UserSerializer.new(@user, options)
  end
end
