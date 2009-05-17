module Scrobbler
  class Event < Base
    attr_accessor :id, :title, :start_date, :start_time, :description, :attendance
    attr_accessor :reviews, :tag, :url, :artists, :headliner, :image_small, :image_medium, :image_large
    
    class << self
      def new_from_libxml(xml)        

        data = {}
        artists = []
        headliner = nil

        xml.children.each do |child|
          data[:id] = child.content if child.name == 'id'
          data[:title] = child.content if child.name == 'title'

          if child.name == 'artists'
            child.children.each do |artist_element|
              artists << Artist.new(artist_element.content) if artist_element.name == 'artist'
              headliner = Artist.new(artist_element.content) if artist_element.name == 'headliner'
            end
            artists << headliner unless headliner.nil?
          end

          if child.name == 'image'
            data[:image_small] = child.content if child['size'] == 'small'
            data[:image_medium] = child.content if child['size'] == 'medium'
            data[:image_large] = child.content if child['size'] == 'large'
          end
  
          data[:url] = child.content if child.name == 'url'
          data[:description] = child.content if child.name == 'description'
          data[:attendance] = child.content if child.name == 'attendance'
          data[:reviews]    = child.content if child.name == 'reviews'
          data[:tag]        = child.content if child.name == 'tag'
          data[:start_date]  = child.content if child.name == 'startDate'
          data[:start_time] = child.content if child.name == 'startTime'

          
        end

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
        #          event.start_date = xml['startDate']
        #          event.start_time = xml['startTime']
        
        #        event.attendance = xml.at(:attendance).inner_html
        #        event.reviews = xml.at(:reviews).inner_html
        #        event.tag = xml.at(:tag).inner_html
        #        event.url = xml.at(:url).inner_html
        #event
        event = Event.new(data[:id],data)
        event.artists = artists
        event.headliner = headliner
        event
      end
    end

    def initialize(id,input={})
      raise ArgumentError if id.blank?      
      @id = id
      populate_data(input)
    end

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