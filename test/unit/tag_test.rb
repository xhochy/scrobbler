require File.dirname(__FILE__) + '/../test_helper.rb'

class TestTag < Test::Unit::TestCase
  def setup
    @tag = Scrobbler::Tag.new('rock')
  end
  
  test 'should require name' do
    assert_raise(ArgumentError) { Scrobbler::Tag.new('') }
  end
  
  test 'should have name' do
    assert_equal('rock', @tag.name)
  end
  
  test 'should be able to find top artists for a tag' do
    assert_equal(50, @tag.top_artists.size)
    assert_equal('ABBA', @tag.top_artists.first.name)
    assert_equal('1229', @tag.top_artists.first.tagcount)
    assert_equal(true, @tag.top_artists.first.streamable)
    assert_equal('d87e52c5-bb8d-4da8-b941-9f4928627dc8', @tag.top_artists.first.mbid)
    assert_equal('http://www.last.fm/music/ABBA', @tag.top_artists.first.url)
    assert_equal('http://userserve-ak.last.fm/serve/34/135930.jpg', @tag.top_artists.first.image(:small))
    assert_equal('http://userserve-ak.last.fm/serve/64/135930.jpg', @tag.top_artists.first.image(:medium))
  end
  
  test 'should be able to find top albums for a tag' do
    assert_equal(50, @tag.top_albums.size)
    assert_equal('Overpowered', @tag.top_albums.first.name)
    assert_equal('Róisín Murphy', @tag.top_albums.first.artist.name)
    assert_equal('4c56405d-ba8e-4283-99c3-1dc95bdd50e7', @tag.top_albums.first.artist.mbid)
    assert_equal('http://www.last.fm/music/R%C3%B3is%C3%ADn+Murphy/Overpowered', @tag.top_albums.first.url)
    assert_equal('http://userserve-ak.last.fm/serve/34s/26856969.png', @tag.top_albums.first.image(:small))
    assert_equal('http://userserve-ak.last.fm/serve/64s/26856969.png', @tag.top_albums.first.image(:medium))
    assert_equal('http://userserve-ak.last.fm/serve/126/26856969.png', @tag.top_albums.first.image(:large))
  end
  
  test 'should be able to find top tracks for a tag' do
    assert_equal(50, @tag.top_tracks.size)
    first = @tag.top_tracks.first
    assert_equal('Stayin\' Alive', first.name)
    assert_equal('422', first.tagcount)
    assert_equal(true, first.streamable)
    assert_equal('Bee Gees', first.artist.name)
    assert_equal('bf0f7e29-dfe1-416c-b5c6-f9ebc19ea810', first.artist.mbid)
    assert_equal('http://www.last.fm/music/Bee+Gees/_/Stayin%27+Alive', first.url)
    assert_equal('http://images.amazon.com/images/P/B00069590Q.01._SCMZZZZZZZ_.jpg', first.image(:small))
    assert_equal('http://images.amazon.com/images/P/B00069590Q.01._SCMZZZZZZZ_.jpg', first.image(:medium))
    assert_equal('http://images.amazon.com/images/P/B00069590Q.01._SCMZZZZZZZ_.jpg', first.image(:large))
  end
end
