require 'sinatra'
require 'sinatra/reloader'
require 'omniauth-facebook'
require 'net/http'
require 'json'
require 'time'
require 'dotenv'
require 'pp'
enable :sessions
Dotenv.load

APP_SECRET = ENV['APP_SECRET']
APP_ID = ENV['APP_ID']

class SinatraOmniAuth < Sinatra::Base
  configure do
    set :sessions, true
    set :inline_templates, true
  end

  use OmniAuth::Builder do
    provider :facebook, APP_ID, APP_SECRET,
    scope: "email, user_birthday, public_profile, user_posts", display: "popup",
    info_fields: "email, birthday, gender, first_name, last_name, posts"
  end

  get '/' do
    erb :index
  end

  get '/auth/:provider/callback' do
    @provider = params[:provider]
    @result = request.env['omniauth.auth']
    session[:access_token] = @result['credentials']['token']
    redirect '/index'
  end

  get '/index' do
    "#{session[:access_token]}"
  end
end
SinatraOmniAuth.run! if __FILE__ == $0
