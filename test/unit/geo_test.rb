require File.dirname(__FILE__) + '/../test_helper.rb'

class TestGeo < Test::Unit::TestCase

  def setup
    @geo = Scrobbler::Geo.new('Manchester')

    @similar_artists = ["Megadeth", "Pantera", "Slayer", "Iron Maiden",
      "Anthrax", "Machine Head", "Sepultura", "Motörhead", "Testament",
      "Trivium", "Black Sabbath", "Exodus", "Ozzy Osbourne", "AC/DC",
      "Kreator", "Black Label Society", "Guns N' Roses", "System of a Down",
      "Judas Priest", "Soulfly", "Godsmack", "Children of Bodom", "Slipknot",
      "Disturbed", "Hunter", "Apocalyptica", "Iced Earth", "Annihilator",
      "Rammstein", "KoЯn", "Death Angel", "In Flames", "Lamb of God", "Overkill",
      "Diamond Head", "Damageplan", "Acid Drinkers", "Beatallica", "Stone Sour",
      "Metal Church", "MD.45", "Volbeat", "HammerFall","Black Tide",
      "Rage Against the Machine", "Manowar", "Probot", "Bullet For My Valentine",
      "Flotsam and Jetsam", "Dio", "Roadrunner United", "Venom", "Arch Enemy",
      "Mercyful Fate", "Nuclear Assault", "Destruction", "Blind Guardian",
      "Sacred Reich", "Bruce Dickinson", "Turbo", "Static-X", "Helloween",
      "Zakk Wylde", "Avenged Sevenfold", "W.A.S.P.", "Kat", "Skid Row",
      "DevilDriver", "Danzig", "Heathen", "Mokoma", "Lordi", "Shadows Fall",
      "Chimaira", "Whiplash", "Mudvayne", "Onslaught", "Sodom", "Rage",
      "Forbidden", "Evile", "Savatage", "Scorpions", "DragonForce",
      "Axel Rudi Pell", "Rob Zombie", "Killswitch Engage", "Sebastian Bach",
      "Saxon", "Cavalera Conspiracy", "Voivod", "Drowning Pool",
      "Fear Factory", "Mötley Crüe", "Prong", "Kotiteollisuus", "Stone",
      "Fozzy", "Yngwie Malmsteen", "Deep Purple"]
    @top_albums = ["Master of Puppets", "Metallica", "Ride the Lightning", "Reload"]
    @top_fans = ["Slide15", "Air_Force", "Evile9", "thy_satan", "Aiham", "Quugel"]
    @top_tracks = ['Nothing Else Matters', 'Enter Sandman',
        'The Day That Never Comes', 'One']
  end

  # @apiversion 2.0
  test 'should require location' do
    assert_raises(ArgumentError) { Scrobbler::Geo.new('') }
  end

  # @apiversion 2.0
  test "should know it's location" do
    assert_equal('Manchester', @geo.location)
  end

  test 'should have the correct ical path to current events' do                  
    assert_equal('http://ws.audioscrobbler.com/2.0/geo/Manchester/events.ics', @geo.events(:ical))
  end

  test 'should have the correct rss path to current events' do
    assert_equal('http://ws.audioscrobbler.com/2.0/geo/Manchester/events.rss', @geo.events(:rss))
  end

  # @apiversion 2.0
  test 'should be able to find events' do
    assert_equal(@events, @geo.events.collect(&:title))
#    first = @artist.similar.first
#    assert_equal('Megadeth', first.name)
#    assert_equal('a9044915-8be3-4c7e-b11f-9e2d2ea0a91e', first.mbid)
#    assert_equal('100', first.match)
#    assert_equal('www.last.fm/music/Megadeth', first.url)
#    assert_equal('http://userserve-ak.last.fm/serve/34/8422011.jpg', first.image(:small))
#    assert_equal('http://userserve-ak.last.fm/serve/64/8422011.jpg', first.image(:medium))
#    assert_equal('http://userserve-ak.last.fm/serve/126/8422011.jpg', first.image(:large))
#    assert_equal('1', first.streamable)
  end

  # @apiversion 2.0
#  test 'should be able to find top fans' do
#    assert_equal(@top_fans, @artist.top_fans.collect(&:username))
#    first = @artist.top_fans.first
#    assert_equal('Slide15', first.username)
#    assert_equal('http://www.last.fm/user/Slide15', first.url)
#    assert_equal('http://userserve-ak.last.fm/serve/34/4477633.jpg', first.image(:small))
#    assert_equal('http://userserve-ak.last.fm/serve/64/4477633.jpg', first.image(:medium))
#    assert_equal('http://userserve-ak.last.fm/serve/126/4477633.jpg', first.image(:large))
#    assert_equal('265440672', first.weight)
#  end

  # @apiversion 2.0
#  test 'should be able to find top tracks' do
#    assert_equal(@top_tracks, @artist.top_tracks.collect(&:name))
#    first = @artist.top_tracks.first
#    assert_equal('Nothing Else Matters', first.name)
#    assert_equal('', first.mbid)
#    assert_equal('http://www.last.fm/music/Metallica/_/Nothing+Else+Matters', first.url)
#  end

  # @apiversion 2.0
#  test 'should be able to find top albums' do
#    assert_equal(@top_albums, @artist.top_albums.collect(&:name))
#    first = @artist.top_albums.first
#    assert_equal('Master of Puppets', first.name)
#    assert_equal('fed37cfc-2a6d-4569-9ac0-501a7c7598eb', first.mbid)
#    assert_equal('http://www.last.fm/music/Metallica/Master+of+Puppets', first.url)
#    assert_equal('http://userserve-ak.last.fm/serve/34s/8622967.jpg', first.image(:small))
#    assert_equal('http://userserve-ak.last.fm/serve/64s/8622967.jpg', first.image(:medium))
#    assert_equal('http://userserve-ak.last.fm/serve/126/8622967.jpg', first.image(:large))
#  end

  # @apiversion 2.0
#  test 'should be able to find top tags' do
#    assert_equal(['metal', 'thrash metal', 'heavy metal'], @artist.top_tags.collect(&:name))
#    first = @artist.top_tags.first
#    assert_equal('metal', first.name)
#    assert_equal('100', first.count)
#    assert_equal('http://www.last.fm/tag/metal', first.url)
#  end
end
