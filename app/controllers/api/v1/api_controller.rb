class API::V1::APIController < ApplicationController
  include Pundit
  include API::V1::APIHelper

  skip_before_action :verify_authenticity_token
  before_action :set_headers
  before_action :authenticate

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def authenticate
    authenticate_with_http_token do |token, options|
      payload = JsonWebToken.decode(token)
      if payload[:id]
        @session_identifier = payload.delete(:session_identifier)
        @user = User
                  .joins(:client_sessions)
                  .where(payload)
                  .where(client_sessions: { id: @session_identifier })
                  .first
      end
    end

    head :unauthorized and return unless @user
  end

  def set_headers
    response.headers['Content-Type'] = 'application/vnd.api+json'
  end

  def render_resource_error(resource)
    errors = resource.errors.full_messages.inject([]) do |array, msg|
      array << {
        status: "422",
        detail: msg,
      }
    end
    render json: { errors: errors }, status: :unprocessable_entity and return
  end

  def render_error(status:, title: nil, detail: nil, source_pointer: nil)
    error = { status: Rack::Utils::SYMBOL_TO_STATUS_CODE[status].to_s }
    error[:title] = title if title
    error[:detail] = detail if detail
    if source_pointer
      error[:source] = { pointer: source_pointer }
    end
    render json: { errors: [ error ] }, status: status
  end

  def user_not_authorized
    render json: {
      errors: {
        status: "401",
        detail: "User is not authorized to perform this action",
      }
    }, status: :unauthorized
  end
end
