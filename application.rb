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

  ['', 'about', 'editing', 'work', 'directing', 'contact', 'news'].each do |route|
    get "/#{route}" do
      haml :index
    end
  end

end
