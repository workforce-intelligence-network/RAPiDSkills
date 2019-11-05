class API::V1::APIController < ApplicationController
  skip_before_action :verify_authenticity_token

  private

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
