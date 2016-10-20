require 'sinatra'
require './config/sidekiq'
require './jobs/hello_job'

class IsuconApp < Sinatra::Base
  get '/' do
    'index'
  end

  get '/hello/:message' do
    HelloJob.perform_async(params[:message])
  end
end
