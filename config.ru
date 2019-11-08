# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

# https://github.com/rails/rails/issues/21068#issuecomment-126241071
use Rack::Rewrite do
  # Redirect /v1/docs to have trailing slash
  r301 '/api/v1/docs', '/api/v1/docs/'

  # For Vue front-end
  r301 '/dist', '/dist/'
end

run Rails.application
