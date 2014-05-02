require 'sinatra/base'

class Web < Sinatra::Base

  configure do
    set :public_folder, 'dist'
  end

  get "/" do
    redirect '/dist.html'
  end

end