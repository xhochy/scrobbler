require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Scrobbler::Library do

  before(:all) do 
    @library = Scrobbler::Library.new('RJ')
  end
  
  it 'should know its username' do
    @library.user.should be_kind_of(Scrobbler::User)
    @library.user.name.should eql('RJ')
  end
  
  it 'should implement all methods from the Last.fm 2.0 API' do
    @library.should respond_to(:add_album)
    @library.should respond_to(:add_artist)
    @library.should respond_to(:add_track)
    @library.should respond_to(:albums)
    @library.should respond_to(:artists)
    @library.should respond_to(:tracks)
  end
  
  it 'should be able to add an album'
  
  it 'should be able to add an artist'
  
  it 'should be able to add a track'
  
  it 'should be able to get its albums'
  
  it 'should be able to get its artists'
  
  it 'should be able to get its tracks'
  
end
