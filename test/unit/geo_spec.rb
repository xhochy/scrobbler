require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Scrobbler::Geo do
  
  before do
    @geo = Scrobbler::Geo.new
    @event_titles = ['Will and The People','Son Of Dave','Surface Unsigned','Experimental Dental School']
    @event_ids = [1025661,954053,1005964,909456]
    @first_atrists_names = ['Will And The People','Carnations','Midwich Cuckoos','NO FLASH']
    @first_headliner = 'Will And The People'
    @top_artist_names = ['The Killers','Coldplay','Radiohead','Muse','Franz Ferdinand','U2']
    @top_track_names = ['Use Somebody','Schwarz zu Blau','Sex on Fire','Alles Neu','Poker Face','Ayo Technology']
  end
 
  describe 'finding events in manchester' do
    before do
      @events =  @geo.events('Manchester')
    end

    it 'should find 4 events' do
      @events.size.should eql 4
    end
   
    it "should have the correct event id's" do
      @events.collect(&:id).should eql @event_ids
    end

    it 'should have the correct event titles' do
      @events.collect(&:title).should eql @event_titles
    end
  end

  describe 'finding top artists in spain' do
    before do
      @top_artists = @geo.top_artists('spain')
    end

    it 'should find 6 artists' do
      @top_artists.size.should eql 6
    end

    it 'should have the correct artist names' do      
      @top_artists.collect(&:name).should eql @top_artist_names
    end
  end

  describe 'finding top tracks' do
    before do
      @top_tracks = @geo.top_tracks('germany')
    end

    it 'should find 6 top tracks' do
      @top_tracks.size.should eql 6
    end

    it 'should have the correct top track names' do
      @top_track_names.should eql @top_tracks.collect(&:name)
    end
  end
end