require File.dirname(__FILE__) + '/../test_helper.rb'

class TestGeo < Test::Unit::TestCase

  def setup
    @geo = Scrobbler::Geo.new
    @events = ['Will and The People','Son Of Dave','Surface Unsigned',
      'Experimental Dental School']
    @ids = [1025661,954053,1005964,909456]
    @first_atrists_names = ['Will And The People','Carnations','Midwich Cuckoos','NO FLASH']
    @first_headliner = 'Will And The People'
    @top_artist_names = ['The Killers','Coldplay','Radiohead','Muse','Franz Ferdinand','U2']
    @top_track_names = ['Use Somebody','Schwarz zu Blau','Sex on Fire','Alles Neu','Poker Face','Ayo Technology']
  end

  # @apiversion 2.0
  test 'should be able to find events' do
    events =  @geo.events('Manchester')
    assert_equal(@ids,events.collect(&:id))
    assert_equal(@events, events.collect(&:title))
  end

  test 'first event should have the correct details' do
    first = @geo.events('Manchester').first
    assert_equal(@first_atrists_names, first.artists.collect(&:name))
    assert_equal(@first_headliner, first.headliner.name)
    assert_equal('http://www.last.fm/event/1025661', first.url)
    assert_equal('http://userserve-ak.last.fm/serve/34/24035067.jpg', first.image_small)
    assert_equal('http://userserve-ak.last.fm/serve/64/24035067.jpg', first.image_medium)
    assert_equal('http://userserve-ak.last.fm/serve/126/24035067.jpg', first.image_large)    
    assert_equal('Sed sed lectus hendrerit urna imperdiet bibendum.', first.description)
    assert_equal(2, first.attendance)
    assert_equal(0, first.reviews)
    assert_equal('lastfm:event=1025661', first.tag)
    assert_equal(Time.parse('Sun, 10 May 2009'), first.start_date)
    assert_equal('19:30', first.start_time)
  end

  test 'first event should have the correct venue' do
    venue = @geo.events('Manchester').first.venue
    assert_equal('Ruby Lounge',venue.name)
    assert_equal('28-34 High Street',venue.street)
    assert_equal('Manchester',venue.city)
    assert_equal('M4 1QB',venue.postalcode)
    assert_equal('GMT',venue.timezone)
    assert_equal('http://www.last.fm/venue/8843135',venue.url)
    assert_equal('53.482827',venue.geo_lat)
    assert_equal('-2.238715',venue.geo_long)
  end

  test 'should be able to find top artists' do
    top_artists = @geo.top_artists('spain')
    assert_equal(@top_artist_names,top_artists.collect(&:name))
  end

  test 'first top artist has the correct attributes' do
    top_artist = @geo.top_artists('spain').first
    assert_equal('The Killers',top_artist.name)
    assert_equal(2635,top_artist.playcount)
    assert_equal('95e1ead9-4d31-4808-a7ac-32c3614c116b',top_artist.mbid)
    assert_equal('http://www.last.fm/music/The+Killers',top_artist.url)
    assert_equal(true,top_artist.streamable)
    assert_equal('http://userserve-ak.last.fm/serve/34/95070.jpg',top_artist.image_small)
    assert_equal('http://userserve-ak.last.fm/serve/64/95070.jpg',top_artist.image_medium)
    assert_equal('http://userserve-ak.last.fm/serve/126/95070.jpg',top_artist.image_large)
  end

  test 'should be able to find top tracks' do
    top_tracks = @geo.top_tracks('germany')
    assert_equal(@top_track_names,top_tracks.collect(&:name))
  end

  test 'first top track has the correct attributes' do
    top_track = @geo.top_tracks('germany').first
    assert_equal('Use Somebody',top_track.name)
    assert_equal(2819,top_track.playcount)
    assert_equal('1234567abcde',top_track.mbid)
    assert_equal('http://www.last.fm/music/Kings+of+Leon/_/Use+Somebody',top_track.url)    
    assert_equal('Kings of Leon',top_track.artist.name)
    assert_equal('6ffb8ea9-2370-44d8-b678-e9237bbd347b',top_track.artist.mbid)
    assert_equal('http://www.last.fm/music/Kings+of+Leon',top_track.artist.url)
  end
end