class API::V1::APIController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate

  private

  def authenticate
    authenticate_with_http_token do |token, options|
      payload = JsonWebToken.decode(token)
      if payload[:id]
        @session_identifier = payload.delete(:session_identifier)
        @user = User
                  .joins(:client_sessions)
                  .where(payload)
                  .where(client_sessions: { identifier: @session_identifier })
                  .first
      end
    end

    head :unauthorized and return unless @user
  end

  def render_resource_error(resource)
    render json: {
      errors: [
        {
          status: "422",
          detail: resource.errors.full_messages.to_sentence,
        }
      ]
    }, status: :unprocessable_entity and return
  end
end
