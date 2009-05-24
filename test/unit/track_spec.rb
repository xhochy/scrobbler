require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Scrobbler::Track do

  before(:all) do 
    @track = Scrobbler::Track.new('Carrie Underwood', 'Before He Cheats')
  end
  
  it 'should know the artist' do
    @track.artist.should eql('Carrie Underwood')
  end
  
  it 'should know the name' do
    @track.name.should eql('Before He Cheats')
  end
  
  it 'should implement all methods from the Last.fm 2.0 API' do
    @track.should respond_to(:add_tags)
    @track.should respond_to(:ban)
    @track.should respond_to(:load_info)
    @track.should respond_to(:similar)
    @track.should respond_to(:tags)
    @track.should respond_to(:top_tags)
    @track.should respond_to(:top_fans)
    @track.should respond_to(:love)
    @track.should respond_to(:remove_tag)
    @track.should respond_to(:search)
    @track.should respond_to(:share)
  end
  
  it 'should be able to add tags'
  
  it 'should be able to be banned'
  
  it 'should be able to load more information'
  
  it 'should be able to get similar tracks'
  
  it 'should be able to get the user\'s tags'
  
  it 'should be able to get its top tags' do
    @track.top_tags.should be_kind_of(Array)
    @track.top_tags.should have(100).items
    @track.top_tags.first.should be_kind_of(Scrobbler::Tag)
    @track.top_tags.first.name.should eql('pop')
    @track.top_tags.first.count.should eql(924808)
    @track.top_tags.first.url.should eql('www.last.fm/tag/pop')
  end
  
  it 'should be able to get its top fans' do
    @track.top_fans.should be_kind_of(Array)
    @track.top_fans.should have(3).items
    @track.top_fans.first.should be_kind_of(Scrobbler::User)
    @track.top_fans.first.name.should eql('ccaron0')
    @track.top_fans.first.url.should eql('http://www.last.fm/user/ccaron0')
    @track.top_fans.first.image(:small).should eql('')
    @track.top_fans.first.image(:medium).should eql('')
    @track.top_fans.first.image(:large).should eql('')
    @track.top_fans.first.weight.should eql(335873)
  end
  
  it 'should be able to love this track'
  
  it 'should be able to remove a tag'
  
  it 'should be able to search for a track'
  
  it 'should be able to share a track'
  
end

