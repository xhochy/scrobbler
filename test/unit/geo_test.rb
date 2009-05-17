require File.dirname(__FILE__) + '/../test_helper.rb'

class TestGeo < Test::Unit::TestCase

  def setup
    @geo = Scrobbler::Geo.new('Manchester')

    @events = ['Will and The People','Son Of Dave','Surface Unsigned',
      'Experimental Dental School']
    @ids = ['1025661','954053','1005964','909456']
    @first_atrists_names = ['Will And The People','Carnations','Midwich Cuckoos','NO FLASH','Will And The People']
    @first_headliner = 'Will And The People'
  end

  # @apiversion 2.0
  test 'should require location' do
    assert_raises(ArgumentError) { Scrobbler::Geo.new('') }
  end

  # @apiversion 2.0
  test "should know it's location" do
    assert_equal('Manchester', @geo.location)
  end

  # @apiversion 2.0
  test 'should be able to find events' do
    assert_equal(@ids, @geo.events(:rss).collect(&:id))
    assert_equal(@events, @geo.events(:rss).collect(&:title))
    first = @geo.events.first
    assert_equal(@first_atrists_names, first.artists.collect(&:name))
    assert_equal(@first_headliner, first.headliner.name)

    assert_equal('http://www.last.fm/event/1025661', first.url)
    assert_equal('http://userserve-ak.last.fm/serve/34/24035067.jpg', first.image_small)
    assert_equal('http://userserve-ak.last.fm/serve/64/24035067.jpg', first.image_medium)
    assert_equal('http://userserve-ak.last.fm/serve/126/24035067.jpg', first.image_large)    
    assert_equal('Sed sed lectus hendrerit urna imperdiet bibendum.', first.description)
    assert_equal('2', first.attendance)
    assert_equal('0', first.reviews)
    assert_equal('lastfm:event=1025661', first.tag)
    assert_equal('Sun, 10 May 2009', first.start_date)
    assert_equal('19:30', first.start_time)
  end

end
