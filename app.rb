require 'sinatra'
require './lib/twitter_auth'

configure do
  set :public_folder, Proc.new {File.join(root, "static")}
  enable :sessions
  set :sessions, secret: '$sujB&b6kF6F65yf^D$4'
end

helpers do
  
  def login_valido 
    if !(session[:consumer_key] && session[:consumer_secret] && session[:oauth_token] && session[:oauth_token_secret]) then
      return false
    end
    return true 
  end
  
  def preenchimento_valido (consumer_key, consumer_secret, oauth_token, oauth_token_secret) 
    if (consumer_key.empty? or consumer_secret.empty? && oauth_token.empty? && oauth_token_secret.empty?) then
      return false
    end
    return true 
  end
    
end

before '/secure/*' do
  if (!login_valido) then
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
  if (preenchimento_valido(params[:token], params[:token_secret], params[:consumer_key],params[:consumer_secret])) then
    session[:oauth_token] = params[:token]
    session[:oauth_token_secret] = params[:token_secret]
    session[:consumer_key] = params[:consumer_key]
    session[:consumer_secret] = params[:consumer_secret]
    redirect '/secure/timeline'  
  end
  
  @error = 'Login inválido. Verifique os dados preenchidos.'
  halt erb(:index)
  
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
  @tweets = nil
  session.delete(:consumer_key)
  session.delete(:consumer_secret)
  session.delete(:oauth_token)
  session.delete(:oauth_token_secret)
  erb :logout
 
end