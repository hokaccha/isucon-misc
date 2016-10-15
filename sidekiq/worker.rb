require 'sidekiq'
require './jobs/hello_job'

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost', namespace: 'sidekiq' }
end