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
  
  test 'should have api path' do
    assert_equal('/1.0/user/jnunemaker', @user.api_path)
  end
  
  test 'should know the correct current events addresses' do
    assert_equal('http://ws.audioscrobbler.com/1.0/user/jnunemaker/events.ics', @user.current_events(:ical))
    assert_equal('http://ws.audioscrobbler.com/1.0/user/jnunemaker/events.ics', @user.current_events(:ics))
    assert_equal('http://ws.audioscrobbler.com/1.0/user/jnunemaker/events.rss', @user.current_events(:rss))
  end
  
  test 'should know the correct friends events addresses' do
    assert_equal('http://ws.audioscrobbler.com/1.0/user/jnunemaker/friendevents.ics', @user.friends_events(:ical))
    assert_equal('http://ws.audioscrobbler.com/1.0/user/jnunemaker/friendevents.ics', @user.friends_events(:ics))
    assert_equal('http://ws.audioscrobbler.com/1.0/user/jnunemaker/friendevents.rss', @user.friends_events(:rss))
  end
  
  test 'should know the correct recommended events addresses' do
    assert_equal('http://ws.audioscrobbler.com/1.0/user/jnunemaker/eventsysrecs.ics', @user.recommended_events(:ical))
    assert_equal('http://ws.audioscrobbler.com/1.0/user/jnunemaker/eventsysrecs.ics', @user.recommended_events(:ics))
    assert_equal('http://ws.audioscrobbler.com/1.0/user/jnunemaker/eventsysrecs.rss', @user.recommended_events(:rss))
  end
  
  test 'should be able to include profile during initialization' do
    user = Scrobbler::User.new('jnunemaker', :include_profile => true)
    assert_equal('3017870', user.id)
    assert_equal('4', user.cluster)
    assert_equal('http://www.last.fm/user/jnunemaker/', user.url)
    assert_equal('John Nunemaker', user.realname)
    assert_equal('d5bbe280b7a41d4a87253361692ef105b983cf1a', user.mbox_sha1sum)
    assert_equal('Dec 8, 2005', user.registered)
    assert_equal('1134050307', user.registered_unixtime)
    assert_equal('25', user.age)
    assert_equal('m', user.gender)
    assert_equal('United States', user.country)
    assert_equal('13267', user.playcount)
    assert_equal('http://panther1.last.fm/avatar/5cb420de0855dadf6bcb1090d8ff02bb.jpg', user.avatar)
  end
  
  test 'should be able to load users profile' do
    @user.load_profile
    assert_equal('3017870', @user.id)
    assert_equal('4', @user.cluster)
    assert_equal('http://www.last.fm/user/jnunemaker/', @user.url)
    assert_equal('John Nunemaker', @user.realname)
    assert_equal('d5bbe280b7a41d4a87253361692ef105b983cf1a', @user.mbox_sha1sum)
    assert_equal('Dec 8, 2005', @user.registered)
    assert_equal('1134050307', @user.registered_unixtime)
    assert_equal('25', @user.age)
    assert_equal('m', @user.gender)
    assert_equal('United States', @user.country)
    assert_equal('13267', @user.playcount)
    assert_equal('http://panther1.last.fm/avatar/5cb420de0855dadf6bcb1090d8ff02bb.jpg', @user.avatar)
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
  end
  
  test 'should be able to get top albums' do
    assert_equal(3, @user.top_albums.size)
    first = @user.top_albums.first
    assert_equal('Skid Row', first.artist)
    assert_equal('6da0515e-a27d-449d-84cc-00713c38a140', first.artist_mbid)
    assert_equal('Slave To The Grid', first.name)
    assert_equal('251', first.playcount)
    assert_equal('1', first.rank)    
    assert_equal('http://www.last.fm/music/Skid+Row/Slave+To+The+Grid', first.url)
    assert_equal('http://userserve-ak.last.fm/serve/34s/12621887.jpg', first.image(:small))
    assert_equal('http://userserve-ak.last.fm/serve/64s/12621887.jpg', first.image(:medium))
    assert_equal('http://userserve-ak.last.fm/serve/126/12621887.jpg', first.image(:large))
  end
  
  test 'should be able to get top tracks' do
    assert_equal(3, @user.top_tracks.size)
    first = @user.top_tracks.first
    assert_equal("Learning to Live", first.name)
    assert_equal('Dream Theater', first.artist)
    assert_equal('28503ab7-8bf2-4666-a7bd-2644bfc7cb1d', first.artist_mbid)
    assert_equal("", first.mbid)
    assert_equal('51', first.playcount)
    assert_equal('1', first.rank)
    assert_equal('http://www.last.fm/music/Dream+Theater/_/Learning+to+Live', first.url)
  end
  
  test 'should be able to get top tags' do
    assert_equal(7, @user.top_tags.size)
    first = @user.top_tags.first
    assert_equal("rock", first.name)
    assert_equal("16", first.count)
    assert_equal("www.last.fm/tag/rock", first.url)
  end
  
  # not implemented
  test 'should be able to get top tags for artist' do
  end
  # not implemented
  test 'should be able to get top tags for album' do
  end
  # not implemented
  test 'should be able to get top tags for track' do
  end
  
  test 'should have friends' do
    assert_equal(3, @user.friends.size)
    first = @user.friends.first
    assert_equal('lobsterclaw', first.username)
    assert_equal('http://www.last.fm/user/lobsterclaw', first.url)
    assert_equal('http://userserve-ak.last.fm/serve/34/1733471.jpg', first.avatar)
  end
  
  test 'should have neighbours' do
    assert_equal(2, @user.neighbours.size)
    first = @user.neighbours.first
    assert_equal('Driotheri', first.username)
    assert_equal('http://www.last.fm/user/Driotheri', first.url)
    assert_equal('http://userserve-ak.last.fm/serve/34/6070771.jpg', first.avatar)
  end
  
  test 'should have recent tracks' do
    assert_equal(3, @user.recent_tracks.size)
    first = @user.recent_tracks.first
    assert_equal('Liquid Dreams', first.name)
    assert_equal('Liquid Tension Experiment', first.artist)
    assert_equal('bc641be9-ca36-4c61-9394-5230433f6646', first.artist_mbid)
    assert_equal('', first.mbid)
    assert_equal('6c20d297-121e-47d0-aa3a-8f27c7a06553', first.album_mbid)
    assert_equal('Liquid Tension Experiment 2', first.album)
    assert_equal('http://www.last.fm/music/Liquid+Tension+Experiment/_/Liquid+Dreams', first.url)
    assert_equal(Time.mktime(2009, 4, 28, 17, 54, 00), first.date)
    assert_equal('1240941262', first.date_uts)
    assert_equal(true, first.now_playing)
  end
  
end
