module Scrobbler
  class Event < Base
    attr_accessor :id, :title, :start_date, :start_time, :description, :attendance
    attr_accessor :reviews, :tag, :url, :artists
    class << self
      def new_from_xml(xml, doc)
        require 'pp'

        event = Event.new()
        event.id = xml.at(:id).inner_html
        event.title = xml.at(:title).inner_html
        #event.artists <<
        event.artists = []
        xml.at(:artists).traverse_element do |artist|
          puts '===='
          #event.artists <<
          unless artist.at(:artist).nil?
            pp artist.at(:artist).inner_html
          end

          unless artist.at(:headliner).nil?
            pp artist.at(:headliner).inner_html
          end
        end
        #<artists>
        #  <artist>Will And The People</artist>
        #  <artist>Carnations</artist>
        #  <artist>Midwich Cuckoos</artist>
        #  <artist>NO FLASH</artist>
        #  <headliner>Will And The People</headliner>
        #</artists>

        #  <venue>
        #  <name>Ruby Lounge</name>
        #  <location>
        #    <city>Manchester</city>
        #    <country>United Kingdom</country>
        #    <street>28-34 High Street</street>
        #    <postalcode>M4 1QB</postalcode>
        #    <geo:point>
        #      <geo:lat>53.482827</geo:lat>
        #      <geo:long>-2.238715</geo:long>
        #    </geo:point>

        #    <timezone>GMT</timezone>
        #   </location>
        #  <url>http://www.last.fm/venue/8843135</url>
        # </venue>
          event.start_date = xml['startDate']
          event.start_time = xml['startTime']
          event.description = xml.at(:description).inner_html

        #<image size="small">http://userserve-ak.last.fm/serve/34/24035067.jpg</image>
        #<image size="medium">http://userserve-ak.last.fm/serve/64/24035067.jpg</image>
        #<image size="large">http://userserve-ak.last.fm/serve/126/24035067.jpg</image>

        
        event.attendance = xml.at(:attendance).inner_html
        event.reviews = xml.at(:reviews).inner_html
        event.tag = xml.at(:tag).inner_html
        event.url = xml.at(:url).inner_html
        event
      end
    end

    #def initialize(from, to)
    #  raise ArgumentError, "From is required" if from.blank?
    #  raise ArgumentError, "To is required" if to.blank?
    #  @from = from
    #  @to = to
    #end

    def from=(value)
      @from = value.to_i
    end

    def to=(value)
      @to = value.to_i
    end

    def from
      @from.to_i
    end

    def to
      @to.to_i
    end
  end
end