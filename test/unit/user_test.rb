require File.dirname(__FILE__) + '/../test_helper.rb'

class TestUser < Test::Unit::TestCase

  def setup
    @user = Scrobbler::User.new('jnunemaker')
  end
  
  test 'should be able to find one user' do
    assert_equal(@user.username, Scrobbler::User.find('jnunemaker').username)
  end
  
  test 'should be able to find multiple users' do
    users = Scrobbler::User.find('jnunemaker', 'oaknd1', 'wharle')
    assert_equal(%w{jnunemaker oaknd1 wharle}, users.collect(&:username))
  end
  
  test 'should be able to find multiple users using an array' do
    users = Scrobbler::User.find(%w{jnunemaker oaknd1 wharle})
    assert_equal(%w{jnunemaker oaknd1 wharle}, users.collect(&:username))
  end
  
  test 'should require a username' do
    assert_raise(ArgumentError) { Scrobbler::User.new('') }
  end
  
  test 'should know the correct events addresses' do
    assert_equal('http://ws.audioscrobbler.com/2.0/user/jnunemaker/events.ics', @user.events(:ical))
    assert_equal('http://ws.audioscrobbler.com/2.0/user/jnunemaker/events.ics', @user.events(:ics))
    assert_equal('http://ws.audioscrobbler.com/2.0/user/jnunemaker/events.rss', @user.events(:rss))
  end
  
  test 'should have friends' do
    assert_equal(3, @user.friends.size)
    first = @user.friends.first
    assert_equal('lobsterclaw', first.username)
    assert_equal('Laura Weiss', first.realname)
    assert_equal('http://www.last.fm/user/lobsterclaw', first.url)
    assert_equal('http://userserve-ak.last.fm/serve/34/1733471.jpg', first.image(:small))
    assert_equal('http://userserve-ak.last.fm/serve/64/1733471.jpg', first.image(:medium))
    assert_equal('http://userserve-ak.last.fm/serve/126/1733471.jpg', first.image(:large))
  end
  
  test 'should have loved tracks' do
    assert_equal(49, @user.loved_tracks.size)
    track = @user.loved_tracks.first
    assert_equal('Early Mornin\' Stoned Pimp', track.name)
    assert_equal('', track.mbid)
    assert_equal('www.last.fm/music/Kid+Rock/_/Early+Mornin%27+Stoned+Pimp', track.url)
    assert_equal(Time.mktime(2009, 4, 28, 11, 38, 00), track.date)
    assert_equal('Kid Rock', track.artist.name)
    assert_equal('ad0ecd8b-805e-406e-82cb-5b00c3a3a29e', track.artist.mbid)
    assert_equal('http://www.last.fm/music/Kid+Rock', track.artist.url)
    assert_equal('http://userserve-ak.last.fm/serve/34s/3458313.jpg', track.image(:small))
    assert_equal('http://userserve-ak.last.fm/serve/64s/3458313.jpg', track.image(:medium))
    assert_equal('http://userserve-ak.last.fm/serve/126/3458313.jpg', track.image(:large))
  end
  
  test 'should have neighbours' do
    assert_equal(2, @user.neighbours.size)
    first = @user.neighbours.first
    assert_equal('Driotheri', first.username)
    assert_equal('http://www.last.fm/user/Driotheri', first.url)
    assert_equal('http://userserve-ak.last.fm/serve/34/6070771.jpg', first.image(:small))
    assert_equal('http://userserve-ak.last.fm/serve/64/6070771.jpg', first.image(:medium))
    assert_equal('http://userserve-ak.last.fm/serve/126/6070771.jpg', first.image(:large))
    assert_equal('0.00027966260677204', first.match)
  end

  test 'should have recent tracks' do
    assert_equal(10, @user.recent_tracks.size)
    first = @user.recent_tracks.first
    assert_equal('Empty Arms', first.name)
    assert_equal('Stevie Ray Vaughan', first.artist.name)
    assert_equal('f5426431-f490-4678-ad44-a75c71097bb4', first.artist.mbid)
    assert_equal('', first.mbid)
    assert_equal('dfb4ba34-6d3f-4d88-848f-e8cc1e7c24d7', first.album.mbid)
    assert_equal('Sout To Soul', first.album.name)
    assert_equal('http://www.last.fm/music/Stevie+Ray+Vaughan/_/Empty+Arms', first.url)
    assert_equal(Time.mktime(2009, 5, 6, 18, 16, 00), first.date)
    assert_equal(true, first.now_playing)
  end

  test 'should be able to get top albums' do
    assert_equal(3, @user.top_albums.size)
    first = @user.top_albums.first
    assert_equal('Skid Row', first.artist.name)
    assert_equal('6da0515e-a27d-449d-84cc-00713c38a140', first.artist.mbid)
    assert_equal('', first.mbid)
    assert_equal('Slave To The Grid', first.name)
    assert_equal('251', first.playcount)
    assert_equal('1', first.rank)    
    assert_equal('http://www.last.fm/music/Skid+Row/Slave+To+The+Grid', first.url)
    assert_equal('http://userserve-ak.last.fm/serve/34s/12621887.jpg', first.image(:small))
    assert_equal('http://userserve-ak.last.fm/serve/64s/12621887.jpg', first.image(:medium))
    assert_equal('http://userserve-ak.last.fm/serve/126/12621887.jpg', first.image(:large))
  end
  
  test "should be able to get a user's top artists" do
    assert_equal(3, @user.top_artists.size)
    first = @user.top_artists.first
    assert_equal('Dream Theater', first.name)
    assert_equal('28503ab7-8bf2-4666-a7bd-2644bfc7cb1d', first.mbid)
    assert_equal('1643', first.playcount)
    assert_equal('1', first.rank)
    assert_equal('http://www.last.fm/music/Dream+Theater', first.url)
    assert_equal('http://userserve-ak.last.fm/serve/34/5535004.jpg', first.image(:small))
    assert_equal('http://userserve-ak.last.fm/serve/64/5535004.jpg', first.image(:medium))
    assert_equal('http://userserve-ak.last.fm/serve/126/5535004.jpg', first.image(:large))
    assert_equal(true, first.streamable)
  end

  test 'should be able to get top tags' do
    assert_equal(7, @user.top_tags.size)
    first = @user.top_tags.first
    assert_equal("rock", first.name)
    assert_equal("16", first.count)
    assert_equal("www.last.fm/tag/rock", first.url)
  end
  
  test 'should be able to get top tracks' do
    assert_equal(3, @user.top_tracks.size)
    first = @user.top_tracks.first
    assert_equal('Learning to Live', first.name)
    assert_equal('Dream Theater', first.artist.name)
    assert_equal('28503ab7-8bf2-4666-a7bd-2644bfc7cb1d', first.artist.mbid)
    assert_equal('', first.mbid)
    assert_equal('51', first.playcount)
    assert_equal('1', first.rank)
    assert_equal('http://www.last.fm/music/Dream+Theater/_/Learning+to+Live', first.url)
  end
  
  test 'should be able to get the weekly album chart' do
    assert_equal(36, @user.weekly_album_chart.size)
    first = @user.weekly_album_chart.first
    assert_equal('Nine Inch Nails', first.artist.name)
    assert_equal('b7ffd2af-418f-4be2-bdd1-22f8b48613da', first.artist.mbid)
    assert_equal('df025315-4897-4759-ba77-d2cd09b5b4b6', first.mbid)
    assert_equal('With Teeth', first.name)
    assert_equal('13', first.playcount)
    assert_equal('1', first.rank)    
    assert_equal('http://www.last.fm/music/Nine+Inch+Nails/With+Teeth', first.url)
  end

  test "should be able to get the weekly artist chart" do
    assert_equal(36, @user.weekly_artist_chart.size)
    first = @user.weekly_artist_chart.first
    assert_equal('Nine Inch Nails', first.name)
    assert_equal('b7ffd2af-418f-4be2-bdd1-22f8b48613da', first.mbid)
    assert_equal('26', first.playcount)
    assert_equal('1', first.rank)
    assert_equal('http://www.last.fm/music/Nine+Inch+Nails', first.url)
  end

  test 'should be able to get the weekly track chart' do
    assert_equal(106, @user.weekly_track_chart.size)
    first = @user.weekly_track_chart.first
    assert_equal('Three Minute Warning', first.name)
    assert_equal('Liquid Tension Experiment', first.artist.name)
    assert_equal('bc641be9-ca36-4c61-9394-5230433f6646', first.artist.mbid)
    assert_equal('', first.mbid)
    assert_equal('5', first.playcount)
    assert_equal('1', first.rank)
    assert_equal('www.last.fm/music/Liquid+Tension+Experiment/_/Three+Minute+Warning', first.url)
  end

end
