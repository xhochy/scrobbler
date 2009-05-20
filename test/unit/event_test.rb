require File.dirname(__FILE__) + '/../test_helper.rb'

class TestEvent < Test::Unit::TestCase

  def setup
    @event = Scrobbler::Event.new('328799', {:include_info => true})
  end

  test 'should require id' do
    assert_raise(ArgumentError) { Scrobbler::Event.new('') }
  end

  test "should know it's id" do
    assert_equal('328799',@event.id)
  end

  test "should know it's title" do
    assert_equal('Philip Glass',@event.title)
  end

  test "should know it's start_date" do
    assert_equal('Thu, 12 Jun 2008 19:30:00',@event.start_date)
  end

  test "should know it's description" do
    assert_equal('Nunc vulputate, ante vitae sollicitudin ullamcorper, velit eros ultricies libero.',@event.description)
  end

  test "should know it's image paths" do
    assert_equal('http://userserve-ak.last.fm/serve/34/320636.jpg',@event.image_small)
    assert_equal('http://userserve-ak.last.fm/serve/64/320636.jpg',@event.image_medium)
    assert_equal('http://userserve-ak.last.fm/serve/126/320636.jpg',@event.image_large)
  end

  test "should know it's url" do
    assert_equal('http://www.last.fm/event/328799',@event.url)
  end

  test "should know it's attendance" do
    assert_equal('46',@event.attendance)
  end

  test "should know it's number of reviews" do
    assert_equal('0',@event.reviews)
  end

  test "should know it's tag" do
    assert_equal('lastfm:event=328799',@event.tag)
  end

  test 'creates the correct artists' do
    assert_equal(2,@event.artists.size)
  end

  test 'creates the correct venue' do
    assert_equal('Barbican Centre',@event.venue.name)
  end
end