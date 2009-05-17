module Scrobbler
  class Geo < Base
    attr_accessor :location    

    def initialize(location, data = {})
      raise ArgumentError, "Location is required" if location.blank?
      @location = location
      populate_data(data)
    end

    # Gets a list of events based on the location that
    # the Geo object is set to
    def events(force=false )
      get_response('geo.getevents', :events, 'events', 'event', {'location'=>@location}, force)
    end
  end
end
