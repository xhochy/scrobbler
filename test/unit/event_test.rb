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

  test "can collect it's own information" do
    #assert_equal('Philip Glass',@event.title)
    assert_equal('Thu, 12 Jun 2008 19:30:00',@event.start_date)
    assert_equal('Nunc vulputate, ante vitae sollicitudin ullamcorper, velit eros ultricies libero.',@event.description)
    assert_equal('http://userserve-ak.last.fm/serve/34/320636.jpg',@event.image_small)
    assert_equal('http://userserve-ak.last.fm/serve/64/320636.jpg',@event.image_medium)
    assert_equal('http://userserve-ak.last.fm/serve/126/320636.jpg',@event.image_large)
    assert_equal('http://www.last.fm/event/328799',@event.url)
    assert_equal('46',@event.attendance)
    assert_equal('0',@event.reviews)
    assert_equal('lastfm:event=328799',@event.tag)
#
#        <artists>
#            <artist>Philip Glass</artist>
#            <artist>Orchestra and Chorus of Erfurt Theatre</artist>
#            <headliner>Philip Glass</headliner>
#        </artists>
#        <venue>
#            <name>Barbican Centre</name>
#            <location>
#                <city>London</city>
#                <country>United Kingdom</country>
#                <street>Silk Street</street>
#                <postalcode>EC2Y 8DS</postalcode>
#                <geo:point>
#                    <geo:lat>51.519972</geo:lat>
#                    <geo:long>-0.09334</geo:long>
#                </geo:point>
#            </location>
#            <url>http://www.last.fm/venue/8777860</url>
#        </venue>

  end


#  test 'should require to' do
#    assert_raise(ArgumentError) { Scrobbler::Chart.new('1108296002', '') }
#  end
#
#  test 'should be able to parse to and from that are unix timestamp strings' do
#    chart = Scrobbler::Chart.new('1108296002', '1108900802')
#    assert_equal(1108296002, chart.from)
#    assert_equal(1108900802, chart.to)
#  end
#
#  test 'should be able to parse to and from that are unix timestamp fixnums' do
#    chart = Scrobbler::Chart.new(1108296002, 1108900802)
#    assert_equal(1108296002, chart.from)
#    assert_equal(1108900802, chart.to)
#  end
#
#  test 'should be able to parse to and from that are times' do
#    chart = Scrobbler::Chart.new(Time.at(1108296002), Time.at(1108900802))
#    assert_equal(1108296002, chart.from)
#    assert_equal(1108900802, chart.to)
#  end
end