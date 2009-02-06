require File.dirname(__FILE__) + '/../test_helper.rb'

class TestSearch < Test::Unit::TestCase

  def setup
    @album_name = "Amnesiac"
    @search = Scrobbler::Search.by_album(@album_name)
  end

  test 'should be able to search for an album and return a list of possible matches' do
    assert_not_nil(@search.execute.size)
  end

  test "should have correct api path when searching for an album" do
    assert_equal("/2.0/?method=album.search&album=#{@album_name}&api_key=#{@api_key}", @search.api_path)
  end

#  test 'should require the artist name' do
#    assert_raises(ArgumentError) { Scrobbler::Album.new('', 'Some Hearts') }
#  end
#
#  test 'should require the track name' do
#    assert_raises(ArgumentError) { Scrobbler::Album.new('Carrie Underwood', '') }
#  end
#
#  test 'should know the artist' do
#    assert_equal('Carrie Underwood', @album.artist)
#  end
#
#  test "should know it's name" do
#    assert_equal('Some Hearts', @album.name)
#  end
#
#  test 'should have correct api path' do
#    assert_equal("/1.0/album/Carrie+Underwood/Some+Hearts", @album.api_path)
#  end

end