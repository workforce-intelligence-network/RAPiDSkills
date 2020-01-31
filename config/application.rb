require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RapidSkills
  class Application < Rails::Application
    # For rendering front-end
    # https://stackoverflow.com/a/37979651/1753903
    Rails.application.config.middleware.insert_after(
      ActionDispatch::Static,
      ActionDispatch::Static,
      Rails.root.join("vue", "dist").to_s,
      index: config.public_file_server.index_name,
      headers: config.public_file_server.headers || {}
    )

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :patch, :delete, :options]
      end
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.active_job.queue_adapter = :sidekiq
  end
end
