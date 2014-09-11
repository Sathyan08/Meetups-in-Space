require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'

require_relative 'config/application'

Dir['app/**/*.rb'].each { |file| require_relative file }

helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end
end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/'
  end
end

get '/' do
  erb :index
end

get '/meetups' do
  @meetups = Meetup.all
  @particpants = Participant.all

  erb :'/meetups/index'
end

get '/meetups/submit' do
  erb :'/meetups/submit'
end

post '/meetups/submit' do
  if !current_user.present?

    erb :'/meetups/submit'
  end

  if Meetup.create(name: params["name"], location: params["location"], description: params["description"]).valid?
    new_meetup = Meetup.create(name: params["name"], location: params["location"], description: params["description"])
    Participant.create(meetup_id: new_meetup.id, user_id: current_user.id)

    @meetup = Meetup.where(name: params["name"], location: params["location"], description: params["description"])
    @new    = "Meetup Successfully Created!"

    erb :'/meetups/show'
  end

end

get '/meetups/:id' do

  @meetup  = Meetup.find_by(id: params["id"])
  @new     = ''

  erb :'/meetups/show'
end

get '/auth/github/callback' do
  auth = env['omniauth.auth']

  user = User.find_or_create_from_omniauth(auth)
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/example_protected_page' do
  authenticate!
end
