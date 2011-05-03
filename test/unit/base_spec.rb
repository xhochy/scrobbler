require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe Scrobbler::Base do

  it "should raise exception if API error occures" do
    lambda {
      Scrobbler::Base.request 'user.getinfo', :user => 'invalid_api_key'
    }.should raise_error(Scrobbler::ApiError, 'Invalid API key - You must be granted a valid key by last.fm')
  end

end