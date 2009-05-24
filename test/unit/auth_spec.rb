require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Scrobbler::Auth do

  before(:all) do 
    @auth = Scrobbler::Auth.new('user')
  end
  
  it 'should implement all methods from the Last.fm 2.0 API' do
    @auth.should respond_to(:mobile_session)
    @auth.should respond_to(:session)
    @auth.should respond_to(:token)
    @auth.should respond_to(:websession)
  end
  
  it 'should be able to start a mobile session'
  
  it 'should be able to fetch a session key'
  
  it 'should be able to fetch a request token'
  
  it 'should be able to start a web session'

end
