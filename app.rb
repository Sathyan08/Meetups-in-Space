require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'
# require 'pry'

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
  # @particpants = Participant.all

  erb :'/meetups/index'
end

get '/meetups/submit' do
  @not_signed_in = ''

  erb :'/meetups/submit'
end

post '/meetups/submit' do
  if !current_user.present?
    @not_signed_in = "You are not signed in!  Sign in to add a meetup."

    erb :'/meetups/submit'
  end

  # binding.pry
  new_meetup = Meetup.new(params[:meetup])
  # new_meetup = Meetup.new(name: params["name"], location: params["location"], description: params["description"])

  if new_meetup.save
    # new_meetup = Meetup.create(name: params["name"], location: params["location"], description: params["description"])
    # new_participant = Participant.create(meetup_id: new_meetup.id, user_id: current_user.id)
    # participant = new_meetup.partipants.create(user: current_user)
    new_meetup.users << current_user
    # binding.pry

    @meetup = Meetup.find_by(id: new_meetup.id)
    @new    = "Meetup Successfully Created!"
    @comments     = @meetup.comments

    # binding.pry

    erb :'/meetups/show'
  end

end

post '/meetups/:id' do
  @meetup = Meetup.find_by(id: params["id"])
  @new    = "Meetup successfully joined!"
  @meetup.users << current_user

  @participants = @meetup.participants
  @comments     = @meetup.comments

  erb :'/meetups/show'
end

get '/meetups/:id' do

  @meetup  = Meetup.find_by(id: params["id"])
  @new     = ''
  @participants = @meetup.participants

  @comments     = @meetup.comments

  erb :'/meetups/show'
end

post '/meetups/leave/:id' do

  Participant.where(user_id: current_user.id).destroy_all
  @meetup  = Meetup.find_by(id: params["id"])
  @new     = 'You have left the meetup successfully'
  @participants = @meetup.participants
  @comments     = @meetup.comments

  erb :'/meetups/show'

end

post '/meetups/comment/:id' do
  new_comment = Comment.new(params[:comment])
  @meetup = Meetup.find_by(meetup_id: params["id"])

  if new_comment.save
    new_comment.users << current_user
    # new_comment.meetups << @meetup
    new_comment.meetups << Meetup.find_by(meetup_id: params["id"])
    @new = "Comment successfully added!"
  else
    @new = "Sorry.  An error occurred."
  end
  @participants = @meetup.participants
  @comments     = @meetup.comments

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
