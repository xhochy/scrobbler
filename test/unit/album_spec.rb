require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Scrobbler::Album do

  before(:each) do 
    @album = Scrobbler::Album.new(:name => 'Some Hearts', :artist => 'Carrie Underwood')
    @session = Scrobbler::Session.new(:name => 'john', :subscriber => false, :key => 'd580d57f32848f5dcf574d1ce18d78b2')
  end
  
  it 'should know the artist' do
    @album.artist.name.should eql('Carrie Underwood')
  end
  
  it "should know it's name" do
    @album.name.should eql('Some Hearts')
  end
  
  it "should implement all methods from the Last.fm 2.0 API" do
     @album.should respond_to(:add_tags)
     @album.should respond_to(:buylinks)
     @album.should respond_to(:load_info)
     @album.should respond_to(:tags)
     @album.should respond_to(:top_tags)
     @album.should respond_to(:remove_tag)
     @album.should respond_to(:search)
     @album.should respond_to(:share)
  end
  
  it 'should be able to add tags' do
    @album.add_tags(@session, ['tag1', 'tag2'])
  end
  
  it 'should be able to load album info' do
    @album.load_info
    
    @album.mbid.should eql('a33b9822-9f09-4e19-9d6e-e05af85c727b')
    @album.url.should eql('http://www.last.fm/music/Carrie+Underwood/Some+Hearts')
    @album.release_date.should eql(Time.mktime(2005, 11, 15, 00, 00, 00))
    @album.image(:small).should eql('http://userserve-ak.last.fm/serve/34s/19874169.jpg')
    @album.image(:medium).should eql('http://userserve-ak.last.fm/serve/64s/19874169.jpg')
    @album.image(:large).should eql('http://userserve-ak.last.fm/serve/174s/19874169.jpg')
    @album.image(:extralarge).should eql('http://userserve-ak.last.fm/serve/300x300/19874169.jpg')
    @album.listeners.should eql(131312)
    @album.playcount.should eql(2096260)
    @album.top_tags.should be_kind_of(Array)
    @album.should have(5).top_tags
    @album.top_tags.first.should be_kind_of(Scrobbler::Tag)
    @album.top_tags.first.name.should eql('country')
    @album.top_tags.first.url.should eql('http://www.last.fm/tag/country')
  end
  
  it 'should be able to get the user\'s tags for this album'
  
  it 'should be able to remove tags'
  
  it 'should be able to search for albums'
  
  it 'should be able to get the links to buy this album'
  
  it 'should be able to share a album with a friend'
end
