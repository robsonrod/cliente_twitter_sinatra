require "rubygems"
require 'twitter'

class TwitterAuth

  def initialize(key, secret_key, token, token_secret)
    
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = key 
      config.consumer_secret = secret_key 
      config.oauth_token = token 
      config.oauth_token_secret = token_secret 
    end
    
  end
  
  def timeline
    #TODO Paging =)
    @client.home_timeline({:count => 80})
  end

  def send_msg(msg)
    @client.update(msg)
  end

end