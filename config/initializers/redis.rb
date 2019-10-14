require 'connection_pool'

if Rails.env.test?
  # If REDIS_URL is passed via ENV, use it for tests.
  if ENV.has_key?('REDIS_URL')
    $redis = Redis.new(url: ENV["REDIS_URL"], db: 1)
  else
    # If running inside continuous integration setup, use default port
    $redis = Redis.new
  end
elsif ENV.has_key?("REDIS_URL")
  $redis = Redis.new(url: ENV["REDIS_URL"])
else
  $redis = Redis.new
end

Redis::Objects.redis = ConnectionPool.new(size: 5, timeout: 5) { $redis }
