module Scrobbler
  class Venue < Base
    attr_accessor :name, :city, :country, :street, :postalcode
    attr_accessor :geo_lat, :geo_long, :timezone, :url, :id

    class << self
      def new_from_xml(xml)
        data = {}
        xml.children.each do |child|
          data[:name] = child.content if child.name == 'name'
          data[:id] = child.content.to_i if child.name == 'id'
          data[:url] = child.content if child.name == 'url'
          if child.name == 'location'
            child.children.each do |location_element|
              data[:city] = location_element.content if location_element.name == 'city'
              data[:country] = location_element.content if location_element.name == 'country'
              data[:street] = location_element.content if location_element.name == 'street'
              data[:postalcode] = location_element.content if location_element.name == 'postalcode'
              data[:timezone] = location_element.content if location_element.name == 'timezone'

              if location_element.name == 'point'
                location_element.children.each do |geo_element|
                  data[:geo_lat] = geo_element.content if geo_element.name == 'lat'
                  data[:geo_long] = geo_element.content if geo_element.name == 'long'
                end
              end
            end
          end
        end
        Venue.new(data[:name], data)
      end
    end

    def initialize(name,data = {})
      raise ArgumentError if name.blank?
      @name = name
      populate_data(data)
    end
  end
end
