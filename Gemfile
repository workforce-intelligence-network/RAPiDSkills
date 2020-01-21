source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'
gem 'rails', '~> 6.0.1'

# API
gem 'fast_jsonapi'
gem 'jwt'
gem 'kaminari'
gem 'rack-cors'

# Database
gem 'pg'

# Web server
gem 'bootsnap', '>= 1.4.2', require: false
gem 'puma', '~> 3.12'

# Frontend
gem 'sass-rails', '~> 5'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'

# Authorization
gem 'pundit'

# Admin dashboard
gem 'activeadmin'
gem 'devise'

# Documentation
gem 'sinatra'
gem 'rack-rewrite'

# Utilities
gem 'after_party'
gem 'prawn'
gem 'faker'

# Background jobs
gem 'sidekiq'

# Cache store
gem 'redis-objects'
gem 'connection_pool'

# File uploading
gem "aws-sdk-s3", require: false

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

group :development, :test do
  gem 'bullet'
  gem 'factory_bot_rails'
  gem 'pry-nav'
  gem 'rspec-rails', '~> 3.8'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'timecop'
end
