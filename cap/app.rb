require 'sinatra'
require 'sidekiq'
require './jobs/hello_job'

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://isucon1', namespace: 'sidekiq' }
end

class IsuconApp < Sinatra::Base
  get '/' do
    'index'
  end

  get '/hello/:message' do
    HelloJob.perform_async(params[:message])
  end
end
