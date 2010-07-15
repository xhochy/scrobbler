require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Scrobbler::Authentication do
  
  before(:each) do
    @auth = Scrobbler::Authentication.new(:username => 'john') 
  end

  it 'should implement' do
    @auth.should respond_to(:session)
    @auth.should respond_to(:mobile_session)
    @auth.should respond_to(:token)
  end

  it 'should be able to authorize a mobile session' do
    @session = @auth.mobile_session('doe')
    @session.key.should eql('d580d57f32848f5dcf574d1ce18d78b2')
    @session.subscriber.should be_false
    @session.name.should eql('john')
  end

  it 'should be able to authorize a web session'

  it 'should be able to authroize a desktop session' do
    # Check URL generation
    token = @auth.token
    session_url = @auth.session_url(token)
    session_url.should match /http\:\/\/www.last.fm\/api\/auth\/\?api_key=[^&?]*&token=[^&?]*/
    # -- Intemediate step needed in production to let the user grant this application access
    # Check session generation
    @session = @auth.session(token)
    @session.key.should eql('d580d57f32848f5dcf574d1ce18d78b2')
    @session.subscriber.should be_false
    @session.name.should eql('john')
  end

end

