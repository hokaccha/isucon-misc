require 'sidekiq'

host = ENV['RACK_ENV'] == 'production' ? 'isucon1' : 'localhost'
redis_config = {
  url: "redis://#{host}",
  namespace: 'sidekiq',
}

Sidekiq.configure_client do |config|
  config.redis = redis_config
end

Sidekiq.configure_server do |config|
  config.redis = redis_config
end
