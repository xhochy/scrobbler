require File.dirname(__FILE__) + '/../test_helper.rb'

class TestSearch < Test::Unit::TestCase

  def setup
    @album_name = "Amnesiac"
    @api_key = "122345678"
    @search = Scrobbler::Search.new(@api_key)
    #@search = Scrobbler::Search.by_album(@album_name)
  end

  test 'should be able to search for an album and return a list of possible matches' do
    assert_equal(20, @search.by_album(@album_name).size)
  end

  test "should be able to correctly find the album that we're searching for" do
    assert_equal("Make Believe", @search.by_album(@album_name)[0].name)
  end

  test "should have correct api path when searching for an album" do
    @search.type = 'album'
    @search.query = @album_name
    assert_equal("/2.0/?method=album.search&album=#{@album_name}&api_key=#{@api_key}", @search.api_path)
  end

end