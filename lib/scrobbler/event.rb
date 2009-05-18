module Scrobbler
  class Event < Base
    attr_accessor :id, :title, :start_date, :start_time, :description
    attr_accessor :reviews, :tag, :url, :artists, :headliner, :image_small
    attr_accessor :image_medium, :image_large, :attendance, :venue
    
    class << self
      def new_from_libxml(xml)        

        data = {}
        artists = []
        headliner = nil
        venue = nil

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
          venue = Venue.new_from_xml(child) if child.name == 'venue'          
        end
 
        event = Event.new(data[:id],data)
        event.artists = artists
        event.headliner = headliner
        event.venue = venue
        event
      end
    end

    def initialize(id,input={})
      raise ArgumentError if id.blank?
      @id = id
      populate_data(input)
    end
  end
end
