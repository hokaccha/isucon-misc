require 'sinatra'

class IsuconApp < Sinatra::Base
  get '/' do
    'hi'
  end
end
