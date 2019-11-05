# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

# https://github.com/rails/rails/issues/21068#issuecomment-126241071
use Rack::Rewrite do
  # Redirect /v1/docs to have trailing slash
  r301 '/v1/docs', '/v1/docs/'
end

run Rails.application
