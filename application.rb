require 'sinatra/base'
require 'sinatra/reloader'

class Application < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :logging, true

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    haml :index
  end

  get '/philosophy' do
    haml 'portfolio/philosopy'.to_sym
  end
end
