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

  get '/carp' do
    response.headers['X-Accel-Redirect'] = '/reproxy'
    response.headers['X-Reproxy-URL'] = 'https://upload.wikimedia.org/wikipedia/commons/0/08/Hiroshima_carp_insignia.png'
  end
end
