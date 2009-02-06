require File.dirname(__FILE__) + '/../test_helper.rb'

class TestSearch < Test::Unit::TestCase

  def setup
    @artist_name = "Radiohead"
    @album_name = "Amnesiac"
    @track_name = "Knives Out"
    @api_key = "122345678"
    @search = Scrobbler::Search.new(@api_key)  
  end

  test 'should be able to search for an album and return a list of possible matches' do
    assert_equal(20, @search.by_album(@album_name).size)
  end

  test "should be able to correctly find the album that we're searching for" do
    assert_equal("Make Believe", @search.by_album(@album_name)[0].name)
  end

  test "should be able to search for an artist and return a list of possible matches" do
    assert_equal(20, @search.by_artist(@artist_name).size)
  end

  test "should be able to correctly find the artist that we're searching for" do
    assert_equal("Radiohead", @search.by_artist(@artist_name)[0].name)
  end

  test "should be able to search for a track and return a list of possible matches" do
    assert_equal(20, @search.by_track(@track_name).size)
  end

  test "should be able to correctly find the track that we're searching for" do
    assert_equal("Knives Out", @search.by_track(@track_name)[0].name)
  end

  test "should have correct api path when searching for an album" do
    @search.type = 'album'
    @search.query = @album_name
    assert_equal("/2.0/?method=album.search&album=#{@album_name}&api_key=#{@api_key}", @search.api_path)
  end

  test "should have correct api path when searching for an artist" do
    @search.type = 'artist'
    @search.query = @artist_name
    assert_equal("/2.0/?method=artist.search&artist=#{@artist_name}&api_key=#{@api_key}", @search.api_path)
  end

  test "should have correct api path when searching for a track" do
    @search.type = 'track'
    @search.query = @track_name
    assert_equal("/2.0/?method=track.search&track=#{CGI::escape(@track_name)}&api_key=#{@api_key}", @search.api_path)
  end

end