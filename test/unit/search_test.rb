require File.dirname(__FILE__) + '/../test_helper.rb'

class TestSearch < Test::Unit::TestCase

  def setup
    @search = Scrobbler::Search.new()
  end

  test 'should be able to search for an album and return a list of possible matches' do
    assert_not_nil(@search.by_album('Hail To The Thief').size)
  end

end