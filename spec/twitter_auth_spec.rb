require 'rspec'
require 'twitter_auth'

describe TwitterAuth do

  let(:twitterauth) { TwitterAuth.new('XXXXXXXXXXXX','XXXXXXXXXXXX','XXXXXXXXXXXXXX','XXXXXXXXXXXXXXX') }

  describe 'timeline' do
    let(:timeline) { twitterauth.timeline }
    it 'seria para em recuperar os twitts da timeline' do
        timeline.should be    
    end  
  end
  
  describe 'send msg' do
    let(:send_msg) { twitterauth.send_msg "I'm tweeting with @gem! =)" }
    it 'seria para enviar uma mensagem' do
      send_msg.should be  
    end
  end

end