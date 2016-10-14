require './app'
require 'sidekiq/web'

map '/sidekiq' do
  run Sidekiq::Web
end
run IsuconApp
