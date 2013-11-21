require 'sinatra'
require './lib/twitter_auth'

configure do
  set :public_folder, Proc.new {File.join(root, "static")}
  enable :sessions
  set :sessions, secret: '$sujB&b6kF6F65yf^D$4'
end

helpers do
  
  def username?
    if session[:oauth_token].nil? or session[:oauth_token_secret].nil? then
      return false
    end
    return true 
  end
  
  def oauth_token
    return session[:oauth_token]
  end

  def oauth_token_secret
    return session[:oauth_token_secret]
  end
end

before '/secure/*' do
  if !(session[:consumer_key] && session[:consumer_secret] && session[:oauth_token] && session[:oauth_token_secret]) then
    session[:previous_url] = request.path
    @error = 'Desculpe, precisa estar logado para acessar ' + request.path
    halt erb(:index)
  end
  @twitter_auth = TwitterAuth.new(session[:consumer_key],session[:consumer_secret],session[:oauth_token], session[:oauth_token_secret])
end

get '/' do
  erb :index
end

get '/login' do 
  erb :index
end

get '/secure/sendtweet' do 
  erb :send_twitter
end

post '/login' do
  session[:oauth_token] = params[:token]
  session[:oauth_token_secret] = params[:token_secret]
  session[:consumer_key] = params[:consumer_key]
  session[:consumer_secret] = params[:consumer_secret]
  redirect '/secure/timeline'  
end

get '/secure/timeline' do 
  @tweets = @twitter_auth.timeline
  erb :timeline_twitter 
end

post '/secure/sendtweet' do 
  @twitter_auth.send_msg params[:mensagem]
  redirect '/secure/timeline'  
end


get '/logout' do
  session.delete(:consumer_key)
  session.delete(:consumer_secret)
  session.delete(:oauth_token)
  session.delete(:oauth_token_secret)
  erb "<div class='alert alert-message'>Logged out</div>"
end