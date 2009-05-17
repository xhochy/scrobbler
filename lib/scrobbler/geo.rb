module Scrobbler
  class Geo < Base

    # Gets a list of events based on the location that
    # the Geo object is set to
    def events(location, force=false )
      get_response('geo.getevents', :events, 'events', 'event', {'location'=>location}, force)
    end

    def top_artists(country,force=false)
      get_response('geo.gettopartists', :artists, 'topartists', 'artist', {'country'=>country}, force)
    end
  end
end